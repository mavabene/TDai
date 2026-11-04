import {test} from 'node:test';
import assert from 'node:assert/strict';
import * as T from 'three';
import {trackDefaultState,joints,screwDiameter} from '../config.js';
import {createRig,applyState,advanceRotation} from '../kinematics.js';
import {createEnvironment} from '../environment.js';
test('Track reset uses nominal positions within limits and makes mast world-plumb',()=>{
 const state=trackDefaultState();const rig=createRig();applyState(rig,state);
 for(const j of joints)assert.ok(state[j.id]>=j.min&&state[j.id]<=j.max,j.id);
 assert.equal(state.zSlide,1.0486);assert.equal(state.mastSlide,1.85);
 assert.equal(state.upperCrowd,2.45);assert.equal(state.xSlide,.15);
 const up=new T.Vector3(0,1,0).transformDirection(rig.nodes.mastSlide.matrixWorld);
 assert.ok(up.distanceTo(new T.Vector3(0,1,0))<1e-12);
 assert.equal(state.lowerRotary,0);assert.equal(state.upperRotary,0);
});
test('Upper rotary allows continuous +/-200 rpm and screw diameter is four inches',()=>{
 const j=joints.find(j=>j.id==='upperRotary');assert.equal(j.min,-200);assert.equal(j.max,200);
 assert.equal(advanceRotation(0,200,.1),120);assert.equal(advanceRotation(0,-200,.1),-120);
 assert.equal(screwDiameter,4*.0254);
});
test('Desert environment toggles scrub and ground color without moving ground',()=>{
 const scene=new T.Scene();const ground=new T.Mesh(new T.PlaneGeometry(1,1),new T.MeshStandardMaterial());ground.position.y=-1.08;
 const env=createEnvironment(scene,ground);env.setEnabled(true);
 assert.equal(env.scrub.visible,true);assert.equal(ground.material.color.getHex(),0xe4d4b8);
 env.scrub.traverse(o=>{if(o.isMesh){assert.ok(o.material.transparent);assert.ok(o.material.opacity<.5);assert.equal(o.material.depthWrite,false);}});
 env.setEnabled(false);assert.equal(env.scrub.visible,false);assert.equal(ground.material.color.getHex(),0xdce5df);assert.equal(ground.position.y,-1.08);
});
