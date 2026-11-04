import {test} from 'node:test';
import assert from 'node:assert/strict';
import {Box3} from 'three';
import {createScalePerson,PERSON_HEIGHT} from '../scale-person.js';
test('scale silhouette is exactly six feet from sole to crown',()=>{
 const bounds=new Box3().setFromObject(createScalePerson());
 assert.ok(Math.abs(bounds.min.y)<1e-7);
 assert.ok(Math.abs(bounds.max.y-bounds.min.y-PERSON_HEIGHT)<1e-7);
 assert.ok(Math.abs(PERSON_HEIGHT-6*.3048)<1e-12);
});
