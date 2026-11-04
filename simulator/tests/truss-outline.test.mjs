import {test} from 'node:test';
import assert from 'node:assert/strict';
import {Vector3} from 'three';
import {createRig,applyState} from '../kinematics.js';
import {referenceState,geometry as g} from '../config.js';
import {createTrussOutline,positionHolderCap} from '../truss-outline.js';
import {etGeometry,GROUND_Y} from '../measurements.js';
test('holder cap WP equals COR at 195/160 cm and moves with lower crowd',()=>{
 const rig=createRig(),cap=createTrussOutline();positionHolderCap(cap,rig);
 assert.equal(cap.parent,rig.nodes.lowerCrowd);
 const cor=()=>rig.nodes.roll.getWorldPosition(new Vector3());
 const wp=()=>cap.getWorldPosition(new Vector3());
 assert.ok(wp().distanceTo(cor())<1e-10);
 assert.equal(referenceState().mastSlide,1.95);assert.equal(referenceState().lowerCrowd,1.6);
 applyState(rig,{...referenceState(),lowerCrowd:1.8});positionHolderCap(cap,rig);
 assert.ok(Math.abs(wp().distanceTo(cor())-.2)<1e-10);
 applyState(rig,{...referenceState(),zSlide:.5,pitch:20,roll:15});positionHolderCap(cap,rig);
 assert.ok(wp().distanceTo(cor())<1e-10);
});
test('mast and crowd alignment requirement uses their summed axial travel',()=>{
 const rig=createRig(),cap=createTrussOutline();
 const mast=1.8,lower=g.lowerCrowdCOR+g.mastCOR-mast;
 applyState(rig,{...referenceState(),mastSlide:mast,lowerCrowd:lower});positionHolderCap(cap,rig);
 assert.ok(cap.getWorldPosition(new Vector3()).distanceTo(rig.nodes.roll.getWorldPosition(new Vector3()))<1e-10);
});
test('Z-slide changes pin height, listed size, screw stance and outline targets live',()=>{
 const rig=createRig(),cap=createTrussOutline();
 const compute=z=>{
  applyState(rig,{...referenceState(),zSlide:z});positionHolderCap(cap,rig);
  return etGeometry(rig.nodes.roll.getWorldPosition(new Vector3()),new Vector3(0,1,0).transformDirection(cap.matrixWorld),GROUND_Y,cap.getWorldPosition(new Vector3()));
 };
 const a=compute(1.20),b=compute(1.38),outside=compute(.02);
 assert.ok(a.valid&&b.valid);assert.notEqual(a.selected.size,b.selected.size);
 assert.ok(Math.abs(b.pinHeight-a.pinHeight-.18)<1e-10);
 assert.notEqual(a.stance,b.stance);assert.notEqual(a.east.z,b.east.z);assert.notEqual(a.east.y,b.east.y);
 assert.equal(outside.valid,false);assert.equal(outside.east,null);
});
