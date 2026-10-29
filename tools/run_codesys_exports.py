# encoding: utf-8
"""Run with CODESYS --runscript, never with ordinary Python.

Exports disposable project copies. Does not save original projects, compile,
connect online, or promote output over previously reviewed exports.
"""
from __future__ import print_function
from scriptengine import *
import hashlib
import json
import os
import shutil
import tempfile

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
scratch_root = os.path.join(root, '.export-work')
if not os.path.isdir(scratch_root):
    os.makedirs(scratch_root)
run_dir = tempfile.mkdtemp(prefix='run-', dir=scratch_root)
print('TD3_EXPORT_RUN_DIR: ' + run_dir)

def fingerprint(path):
    digest = hashlib.sha256()
    with open(path, 'rb') as stream:
        while True:
            chunk = stream.read(1024 * 1024)
            if not chunk:
                break
            digest.update(chunk)
    return digest.hexdigest()

inputs = [
    ('Production_dev/TD3-Auto/ojjo_TD3_cr711S_530v2.project',
     'StandardPLC.dev/Plc Logic/Application/Global Variables/Version.gvl'),
    ('Production_dev/TD3-HMI/ojjo_TD3_cr1203_530v1.project',
     'Device.dev/Plc Logic/Application/GlobalVariables/VersionHMI.gvl')
]
results = []
for relative, required in inputs:
    source = os.path.join(root, relative)
    before = fingerprint(source)
    copied = os.path.join(run_dir, os.path.basename(source))
    shutil.copy2(source, copied)
    if fingerprint(copied) != before:
        raise RuntimeError('Input changed while copying: ' + relative)
    project = projects.open(copied, update_flags=VersionUpdateFlags.NoUpdates,
                            allow_readonly=True)
    try:
        execfile(os.path.join(root, 'tools', 'codesys_export.py'))
    finally:
        project.close()
    output = os.path.join(run_dir, 'exports_' + os.path.splitext(os.path.basename(source))[0])
    if not os.path.isfile(os.path.join(output, required)):
        raise RuntimeError('Required export missing: ' + required)
    if fingerprint(source) != before:
        raise RuntimeError('Workspace input changed during export: ' + relative)
    results.append({'source': relative, 'sha256': before, 'output': output})

with open(os.path.join(run_dir, 'result.json'), 'w') as stream:
    json.dump({'status': 'exported', 'projects': results,
               'compiled': False, 'library_resolution_verified': False}, stream, indent=2)
print('TD3_EXPORT_ALL_OK: ' + run_dir)
system.exit(0)
