import {test} from 'node:test';
import assert from 'node:assert/strict';
import * as T from 'three';
import {createRig,applyState,worldPosition,machineToRender} from '../kinematics.js';
import {joints,referenceState} from '../config.js';
const near=(a,b)=>assert.ok(Math.abs(a-b)<1e-9,`${a} != ${b}`);
function pose(changes={}){const r=createRig();const base=referenceState();applyState(r,{...base,...Object.fromEntries(Object.entries(changes).map(([k,v])=>[k,v+base[k]]))});return r;}
test('frame maps forward, right and up without conflating axes',()=>{
 assert.deepEqual(machineToRender([1,2,3]).toArray(),[1,3,2]);
 const x=machineToRender([1,0,0]),y=machineToRender([0,1,0]);
 near(x.cross(y).dot(machineToRender([0,0,1])),-1);
});
test('aligned horizontal reach is nominal 2.7 m; X slide adds rearward displacement',()=>{
 const a=worldPosition(pose(),'roll'),b=worldPosition(pose({xSlide:.3}),'roll');
 near(a.x,-2.7);near(b.x-a.x,-.3);near(b.y,a.y);near(b.z,a.z);
 near(worldPosition(pose(),'lowerRotary').x,-2.7);
});
test('positive boom swing and yaw move their arms in opposite lateral directions',()=>{
 assert.ok(worldPosition(pose({boomSwing:10}),'jointLift').z>0);
 assert.ok(worldPosition(pose({yaw:10}),'xSlide').z<0);
});
test('boom lift raises the arm, joint lift tilts trunnion rearward independently',()=>{
 assert.ok(worldPosition(pose({boomLift:10}),'jointLift').y>worldPosition(pose(),'jointLift').y);
 assert.ok(worldPosition(pose({jointLift:10}),'yaw').x<worldPosition(pose(),'yaw').x);
 const a=worldPosition(pose(),'jointLift'),b=worldPosition(pose({jointLift:20}),'jointLift');near(a.distanceTo(b),0);
});
test('pitched Z travel has horizontal displacement; roll does not rotate backbone',()=>{
 const a=pose({pitch:20}),b=pose({pitch:20,zSlide:1});const d=worldPosition(b,'roll').sub(worldPosition(a,'roll'));
 near(d.length(),1);assert.ok(Math.abs(d.x)>.3);near(d.z,0);
 assert.ok(d.x>0,'Owner-corrected positive pitch tilts local up toward machine +X');
 const r=pose({pitch:20,roll:25});assert.deepEqual(r.nodes.pitch.matrixWorld.toArray(),a.nodes.pitch.matrixWorld.toArray());
});
test('mast carries crowds, lower crowd carries upper, upper-only leaves lower fixed',()=>{
 const home=pose();for(const name of ['lowerCrowd','upperCrowd'])near(worldPosition(pose({mastSlide:.7}),name).y-worldPosition(home,name).y,.7);
 near(worldPosition(pose({lowerCrowd:1}),'upperCrowd').y-worldPosition(home,'upperCrowd').y,1);
 near(worldPosition(pose({upperCrowd:.6}),'lowerCrowd').distanceTo(worldPosition(home,'lowerCrowd')),0);
 near(worldPosition(pose({lowerCrowd:1,upperCrowd:.6}),'upperCrowd').y-worldPosition(home,'upperCrowd').y,1.6);
});
test('tools remain coaxial in a combined tilted pose',()=>{
 const r=pose({boomSwing:15,boomLift:12,jointLift:8,yaw:-17,pitch:18,roll:22,mastSlide:.4,lowerCrowd:.3,upperCrowd:.2});
 const a=worldPosition(r,'lowerRotary'),b=worldPosition(r,'upperRotary');
 const axis=new T.Vector3(0,1,0).transformDirection(r.nodes.lowerCrowd.matrixWorld);
 near(b.sub(a).cross(axis).length(),0);
});
test('all individual endpoints and combined endpoints are finite; reset is exact',()=>{
 const r=pose();const start=r.nodes.upperCrowd.matrixWorld.toArray();
 for(const j of joints)for(const v of [j.min,j.max]){applyState(r,{...referenceState(),[j.id]:v});for(const n of Object.values(r.nodes))assert.ok(n.matrixWorld.elements.every(Number.isFinite));}
 for(const key of ['min','max']){applyState(r,Object.fromEntries(joints.map(j=>[j.id,j[key]])));for(const n of Object.values(r.nodes))assert.ok(n.matrixWorld.elements.every(Number.isFinite));}
 applyState(r,referenceState());assert.deepEqual(r.nodes.upperCrowd.matrixWorld.toArray(),start);
});
