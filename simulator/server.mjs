import http from 'node:http';
import {readFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
const root=path.dirname(fileURLToPath(import.meta.url));
const types={'.html':'text/html','.js':'text/javascript','.css':'text/css','.png':'image/png','.json':'application/json'};
const server=http.createServer(async(req,res)=>{
  try {
    const pathname=decodeURIComponent(new URL(req.url,'http://localhost').pathname);
    const reference=pathname.startsWith('/reference/');
    const base=reference?path.resolve(root,'../AI info/machine-images/2026-11-02'):root;
    const relative=reference?pathname.slice(11):(pathname==='/'?'index.html':pathname.slice(1));
    const file=path.resolve(base,relative);
    if(!file.startsWith(base+path.sep)) {res.writeHead(403);res.end();return;}
    const body=await readFile(file);res.writeHead(200,{'Content-Type':types[path.extname(file)]||'application/octet-stream','Cache-Control':'no-store'});res.end(body);
  } catch {res.writeHead(404);res.end('Not found');}
});
server.on('error',e=>{console.error(e.message);process.exitCode=1;});
server.listen(8313,'127.0.0.1',()=>console.log('TD3 model: http://127.0.0.1:8313'));
