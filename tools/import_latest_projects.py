"""Select saved mainline projects; preview by default, copy only with --apply."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import tempfile

SOURCE = Path(r'C:\Users\jcheney\Documents\TD3\Ojjo_TD3-1')
WORKSPACE = Path(__file__).resolve().parents[1]

def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

def version(name, component):
    match = re.fullmatch(r'ojjo_TD3_' + re.escape(component) + r'_(\d+)(?:v(\d+))?\.project', name, re.I)
    return (int(match[1]), int(match[2] or 0)) if match else None

def select(root, component):
    candidates = []
    for folder, dirs, files in os.walk(root, followlinks=False):
        dirs[:] = [d for d in dirs if d != '.git' and not Path(folder, d).is_symlink()]
        for name in files:
            key = version(name, component)
            if key is not None:
                candidates.append((key, Path(folder, name)))
    if not candidates:
        raise RuntimeError('No mainline project found: ' + component)
    highest = max(key for key, path in candidates)
    choices = sorted(path for key, path in candidates if key == highest)
    if len({digest(path) for path in choices}) != 1:
        raise RuntimeError('Conflicting copies of latest version; ask owner: ' + str(choices))
    return choices[0]

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    if not SOURCE.is_dir():
        raise RuntimeError('Source folder unavailable: ' + str(SOURCE))
    plan = []
    for component, target in [('cr711S', 'TD3-Auto'), ('cr1203', 'TD3-HMI')]:
        source = select(SOURCE, component)
        destination = WORKSPACE / 'Production_dev' / target / source.name
        plan.append({'source': str(source), 'destination': str(destination),
                     'sha256': digest(source),
                     'changed': not destination.exists() or digest(destination) != digest(source)})
    print(json.dumps({'mode': 'copy' if args.apply else 'preview', 'projects': plan}, indent=2))
    if not args.apply:
        return
    staged = []
    try:
        for item in plan:
            source, destination = Path(item['source']), Path(item['destination'])
            destination.parent.mkdir(parents=True, exist_ok=True)
            fd, temporary = tempfile.mkstemp(prefix='.import-', dir=destination.parent)
            os.close(fd)
            staged.append((Path(temporary), destination))
            shutil.copyfile(source, temporary)
            if digest(Path(temporary)) != item['sha256'] or digest(source) != item['sha256']:
                raise RuntimeError('Source changed during copy; retry after saving: ' + str(source))
        for temporary, destination in staged:
            os.replace(temporary, destination)
        for item in plan:
            if digest(Path(item['destination'])) != item['sha256']:
                raise RuntimeError('Copied file failed hash verification: ' + item['destination'])
        (WORKSPACE / '.project-import.json').write_text(json.dumps({'projects': plan}, indent=2), encoding='utf-8')
    finally:
        for temporary, destination in staged:
            if temporary.exists():
                temporary.unlink()

if __name__ == '__main__':
    main()
