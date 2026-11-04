import {mkdir,copyFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import {build} from 'esbuild';
// Classic script: viewing needs no module imports, CDN, Node runtime or server.
process.chdir(fileURLToPath(new URL('.',import.meta.url)));
await build({entryPoints:['app.js'],bundle:true,format:'iife',platform:'browser',
  target:'es2020',outfile:'viewer.js',minify:true,legalComments:'eof'});
await mkdir('dist/reference',{recursive:true});
await mkdir('reference',{recursive:true});
for(const file of ['index.html','style.css','viewer.js'])await copyFile(file,`dist/${file}`);
for(const file of ['SHARING.txt','LIMITS.md','MEASUREMENTS.md'])await copyFile(file,`dist/${file}`);
await copyFile('node_modules/three/LICENSE','dist/THREE-LICENSE.txt');
for(const file of ['td3-side-view.png','td3-angled-overview.png']) {
  const source=`../AI info/machine-images/2026-11-02/${file}`;
  await copyFile(source,`reference/${file}`);
  await copyFile(source,`dist/reference/${file}`);
}
console.log('Built viewer.js and portable dist/. Open index.html directly in Chrome.');
