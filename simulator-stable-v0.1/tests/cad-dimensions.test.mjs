import {test} from 'node:test';
import assert from 'node:assert/strict';
import {layoutDimension} from '../cad-dimensions.js';
test('CAD extension endpoints preserve projected span and offset',()=>{
 const d=layoutDimension({x:10,y:20},{x:110,y:20},40);
 assert.deepEqual(d.first,{x:10,y:60});assert.deepEqual(d.second,{x:110,y:60});
 assert.equal(d.angle,0);
 const vertical=layoutDimension({x:30,y:200},{x:30,y:50},25);
 assert.equal(vertical.first.x,55);assert.equal(vertical.second.x,55);
 assert.ok(vertical.angle>=-90&&vertical.angle<=90);
});
test('zero projected length still yields finite readable geometry',()=>{
 const d=layoutDimension({x:10,y:10},{x:10,y:10},40);
 assert.ok(Object.values(d.center).every(Number.isFinite));
});
