import {test} from 'node:test';
import assert from 'node:assert/strict';
import {readFile,access} from 'node:fs/promises';
import {Script} from 'node:vm';
const read=name=>readFile(new URL('../'+name,import.meta.url),'utf8');
test('direct-file entry uses a locally bundled classic script, with a visible load error',async()=>{
  const html=await read('index.html');
  assert.doesNotMatch(html,/type=["'](?:module|importmap)["']/);
  assert.match(html,/<script src="viewer.js" onerror=/);
  assert.match(html,/modelStartupFailed/);
  assert.doesNotMatch(html,/(?:src|href)="https?:/);
  // Compiling as a classic script rejects static imports/exports; do not execute WebGL here.
  new Script(await read('viewer.js'));
  for(const file of ['style.css','reference/td3-side-view.png','reference/td3-angled-overview.png'])
    await access(new URL('../'+file,import.meta.url));
});
test('portable entry and bundle match the source launch assets',async()=>{
  for(const file of ['index.html','viewer.js','style.css'])assert.equal(await read(file),await read('dist/'+file));
});
