import {test} from 'node:test';
import assert from 'node:assert/strict';
import {Vector3} from 'three';
import {createRig,applyState} from '../kinematics.js';
import {referenceState} from '../config.js';
import {createMovementPoints,createPointVisibility} from '../movement-points.js';
test('only the requested eleven actuator points exist and follow their own assemblies',()=>{
 const rig=createRig(),points=createMovementPoints(rig);
 assert.deepEqual(points.map(p=>p.userData.joint).sort(),['boomSwing','yaw','pitch','boomLift','jointLift','roll','xSlide','zSlide','mastSlide','lowerCrowd','upperCrowd'].sort());
 for(const p of points)assert.equal(p.parent,rig.nodes[p.userData.joint]);
 const byId=id=>points.find(p=>p.userData.joint===id);
 const before=byId('upperCrowd').getWorldPosition(new Vector3());
 applyState(rig,{...referenceState(),lowerCrowd:1.8});
 assert.ok(Math.abs(byId('upperCrowd').getWorldPosition(new Vector3()).distanceTo(before)-.2)<1e-12);
 const x=byId('xSlide').getWorldPosition(new Vector3()),pitch=byId('pitch').getWorldPosition(new Vector3());
 assert.ok(x.distanceTo(pitch)>.1,'X-slide and pitch have distinct selectable points');
});
test('points can be hidden, reveal only changed axes, and expire two seconds after last change',()=>{
 const points=createMovementPoints(createRig()),v=createPointVisibility(points),home=referenceState();
 const visible=()=>points.filter(p=>p.visible).map(p=>p.userData.joint).sort();
 v.observe(home,0);assert.equal(visible().length,11);
 v.setShowAll(false,100);assert.deepEqual(visible(),[]);
 v.observe(home,200);assert.deepEqual(visible(),[],'focus/update alone does not reveal points');
 const a={...home,zSlide:1.5};v.observe(a,300);assert.deepEqual(visible(),['zSlide']);
 v.refresh(2299);assert.deepEqual(visible(),['zSlide']);
 v.refresh(2300);assert.deepEqual(visible(),[]);
 const b={...a,lowerCrowd:1.7};v.observe(b,2400);assert.deepEqual(visible(),['lowerCrowd']);
 const c={...b,lowerCrowd:1.8};v.observe(c,4000);v.refresh(5999);assert.deepEqual(visible(),['lowerCrowd']);
 v.refresh(6000);assert.deepEqual(visible(),[]);
 v.observe({...c,upperRotary:200},6100);assert.deepEqual(visible(),[],'drill rotary has no requested pivot marker');
 v.setShowAll(true,6200);assert.equal(visible().length,11);
 v.setShowAll(false,6300);assert.deepEqual(visible(),[]);
});

test('gold slide surfaces follow the same checkbox and transient rules, including shared crowd rails',()=>{
 const surface=(...movementJoints)=>({userData:{movementJoints},visible:true});
 const surfaces=[surface('xSlide'),surface('zSlide'),surface('mastSlide'),surface('lowerCrowd','upperCrowd')];
 const points=createMovementPoints(createRig()),v=createPointVisibility([...points,...surfaces]),home=referenceState();
 v.observe(home,0);v.setShowAll(false,1);assert.ok(surfaces.every(s=>!s.visible));
 v.observe({...home,upperCrowd:.5},100);assert.deepEqual(surfaces.map(s=>s.visible),[false,false,false,true]);
 v.refresh(2100);assert.ok(surfaces.every(s=>!s.visible));
 v.observe({...home,upperCrowd:.5,zSlide:1.2},2200);assert.deepEqual(surfaces.map(s=>s.visible),[false,true,false,false]);
 v.setShowAll(true,2300);assert.ok(surfaces.every(s=>s.visible));
});
