from __future__ import print_function
from scriptengine import *
import os, glob, hashlib, shutil, tempfile, json
root=os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
run=tempfile.mkdtemp(prefix='libraries-',dir=os.path.join(root,'.export-work'))
print('LIBRARY_RUN: '+run)
def sha(p):
 return hashlib.sha256(open(p,'rb').read()).hexdigest()
seen=set(); results=[]
paths=[]
for folder in ['Library','Production_dev/libraries']:
 for pattern in ['td3*.library','motor3*.library']:
  paths.extend(glob.glob(os.path.join(root,folder,pattern)))
for source in sorted(paths):
 before=sha(source)
 if before in seen: continue
 seen.add(before)
 item={'source':source,'sha256':before}; project=None
 try:
  folder=os.path.join(run,str(len(results)+1)); os.makedirs(folder)
  copied=os.path.join(folder,os.path.basename(source)); shutil.copy2(source,copied)
  if sha(copied)!=before: raise RuntimeError('Copy hash mismatch')
  project=projects.open(copied,update_flags=VersionUpdateFlags.NoUpdates,allow_readonly=True)
  try:
   info=project.get_project_info()
   item['identity']={'title':str(info.title),'version':str(info.version),'company':str(info.company)}
  except Exception as ex: item['identity_error']=str(ex)
  execfile(os.path.join(root,'tools','codesys_export.py'))
  output=os.path.join(folder,'exports_'+os.path.splitext(os.path.basename(source))[0])
  item['output']=output
  item['files']=sum(len(f) for a,b,f in os.walk(output))
  item['status']='exported'
 except Exception as ex:
  item['status']='failed'; item['error']=str(ex)
 finally:
  if project is not None: project.close()
  item['source_unchanged']=sha(source)==before
 results.append(item)
 with open(os.path.join(run,'result.json'),'w') as f: json.dump(results,f,indent=2)
 print('LIBRARY_RESULT: '+json.dumps(item))
print('LIBRARY_ALL_FINISHED: '+run)
system.exit(0)
