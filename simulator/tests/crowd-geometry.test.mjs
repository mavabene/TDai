import {test} from 'node:test';
import assert from 'node:assert/strict';
import {Vector3} from 'three';
import {createRig,applyState,worldPosition} from '../kinematics.js';
import {referenceState,geometry as g} from '../config.js';
import {crowdTopClearance,crowdCommandMaximum,drillTipLocalY} from '../crowd-geometry.js';
import {GROUND_Y,measurementEndpoints,spanMeasurement} from '../measurements.js';
const near=(a,b)=>assert.ok(Math.abs(a-b)<1e-10,`${a} != ${b}`);

test('zero upper crowd touches bearing edges; gap stays relative through combined attitudes',()=>{
 const rig=createRig();
 for(const pitch of [-6,0,45,80])for(const roll of [-38,0,38])for(const lowerCrowd of [.37,1.6,2.7])for(const upperCrowd of [0,.01,3]){
  applyState(rig,{...referenceState(),pitch,roll,lowerCrowd,upperCrowd});
  const lowerTop=rig.nodes.lowerCrowd.localToWorld(new Vector3(0,g.sledLength/2,0));
  const upperBottom=rig.nodes.upperCrowd.localToWorld(new Vector3(0,-g.sledLength/2,0));
  const up=new Vector3(0,1,0).transformDirection(rig.nodes.roll.matrixWorld);
  const delta=upperBottom.sub(lowerTop);near(delta.dot(up),upperCrowd);near(delta.cross(up).length(),0);
 }
});

test('centralizer, lower bearing datum, chuck and drill match source formulas over slide travel',()=>{
 const rig=createRig();
 for(const zSlide of [.02,1.5175,1.675])for(const mastSlide of [0,1.95,1.975])for(const lowerCrowd of [.37,1.6,2.7])for(const upperCrowd of [0,2.068,3]){
  applyState(rig,{...referenceState(),zSlide,mastSlide,lowerCrowd,upperCrowd});
  const h=(node,y)=>rig.nodes[node].localToWorld(new Vector3(0,y,0)).y-GROUND_Y;
  const centralizer=-.14+zSlide-(1.975-mastSlide);
  const chuck=centralizer+.16+lowerCrowd-.632;
  near(h('mastSlide',g.mastBottom),centralizer);
  near(h('lowerCrowd',-g.sledLength/2),centralizer+.16+lowerCrowd);
  near(h('lowerRotary',g.chuckBottom),chuck);
  near(h('upperRotary',drillTipLocalY),chuck-(2.068-upperCrowd));
 }
 applyState(rig,referenceState());
 near(worldPosition(rig,'roll').y-GROUND_Y,2.3247);
 near(rig.nodes.lowerRotary.localToWorld(new Vector3(0,g.chuckBottom-g.screwLength,0)).y-GROUND_Y,.4805);
});

test('visible drifter clearance reproduces the active source arithmetic, without compressing the mast',()=>{
 const rig=createRig();
 for(const lowerCrowd of [.37,1.6,2.7])for(const upperCrowd of [0,2.45,3]){
  const state={...referenceState(),lowerCrowd,upperCrowd};applyState(rig,state);
  const top=rig.nodes.mastSlide.localToWorld(new Vector3(0,g.mastTop,0));
  const drifterTop=rig.nodes.upperCrowd.localToWorld(new Vector3(0,1.5*g.sledLength+g.drifterGap,0));
  const source=((278+11)-(3*18.7+5.125))*.0254-lowerCrowd-upperCrowd;
  near(top.y-drifterTop.y,source);near(crowdTopClearance(state),source);
 }
 near(crowdTopClearance({...referenceState(),lowerCrowd:2.7,upperCrowd:0}),3.085485);
 near(crowdTopClearance({...referenceState(),lowerCrowd:2.7,upperCrowd:3}),.085485);
});

test('slide dimensions measure actual zero-to-carriage displacement even when tilted',()=>{
 const rig=createRig(),state={...referenceState(),pitch:35,roll:-20,xSlide:.27,zSlide:1.2,mastSlide:1.8,lowerCrowd:2.1,upperCrowd:.9};
 applyState(rig,state);
 for(const id of ['xSlide','zSlide','mastSlide','lowerCrowd','upperCrowd']){
  const ends=measurementEndpoints(rig,id,[]);near(spanMeasurement(ends.a,ends.b).length,state[id]);
 }
});

test('live crowd limits preserve 5 cm to mast top while holding the other coordinate fixed',()=>{
 for(const lowerCrowd of [.37,1.6,2.7]){
  const state={...referenceState(),lowerCrowd};
  state.upperCrowd=crowdCommandMaximum('upperCrowd',state);
  near(crowdTopClearance(state),.05);
  near(crowdCommandMaximum('lowerCrowd',state),lowerCrowd);
 }
 near(crowdCommandMaximum('upperCrowd',{lowerCrowd:1.6}),4.135485);
 near(crowdCommandMaximum('lowerCrowd',{upperCrowd:0}),2.7);
 near(crowdCommandMaximum('lowerCrowd',{upperCrowd:4}),1.735485);
 assert.equal(crowdCommandMaximum('lowerCrowd',{upperCrowd:4.135485}),1.6,'ET reference remains inside the exact coupled boundary');
});

test('lower bearing stays above the guide bottom at both profile minimums through mast/Z travel and tilt',()=>{
 const rig=createRig();
 for(const lowerCrowd of [.37,.44])for(const mastSlide of [0,1.975])for(const zSlide of [.02,1.675])for(const pitch of [-6,0,80])for(const roll of [-38,0,38]){
  applyState(rig,{...referenceState(),lowerCrowd,mastSlide,zSlide,pitch,roll});
  const bottom=rig.nodes.lowerCrowd.localToWorld(new Vector3(0,-g.sledLength/2,0));
  const rail=rig.nodes.mastSlide.localToWorld(new Vector3(g.toolOffset,g.mastRailBottom,0));
  const up=new Vector3(0,1,0).transformDirection(rig.nodes.mastSlide.matrixWorld);
  const gap=bottom.sub(rail);near(gap.dot(up),lowerCrowd-.2794);near(gap.clone().cross(up).length(),0);
  assert.ok(gap.dot(up)>.09);
 }
});
