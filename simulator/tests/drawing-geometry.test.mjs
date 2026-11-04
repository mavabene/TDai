import {test} from 'node:test';
import assert from 'node:assert/strict';
import {Vector3} from 'three';
import {createRig,applyState,worldPosition} from '../kinematics.js';
import {referenceState,joints} from '../config.js';
import {createTrussOutline,positionHolderCap} from '../truss-outline.js';
import {spanMeasurement,GROUND_Y} from '../measurements.js';
const near=(a,b,tolerance=.0001)=>assert.ok(Math.abs(a-b)<tolerance,`${a} != ${b}`);
test('dimensioned SolidWorks reference pose reproduces independent drawing constraints',()=>{
 const rig=createRig();applyState(rig,{...referenceState(),xSlide:.30,zSlide:1.5175});
 const p=id=>worldPosition(rig,id),bl=p('boomLift'),jl=p('jointLift'),yaw=p('yaw'),pitch=p('pitch'),cor=p('roll');
 near(bl.y-GROUND_Y,.865);near(jl.y-GROUND_Y,1.4498,1e-12);
 near(bl.distanceTo(jl),1.1838);assert.equal(spanMeasurement(bl,jl).angle.toFixed(1),'29.6');
 near((cor.y-GROUND_Y)*1000,2324.7,1e-9);
 near(Math.abs(yaw.x-p('boomSwing').x),1.42929445384);
 near(Math.abs(yaw.x-jl.x),.23);near(Math.abs(pitch.x-jl.x),.82);
 near(pitch.y-jl.y,.8404);near(Math.abs(cor.x-pitch.x),.9332);near(cor.y-pitch.y,.0345);
 const pendulum=p('pendulum');near(pendulum.x-bl.x,.29);near(bl.y-pendulum.y,.423);
});
test('COR height follows Z travel throughout its command range at the level reference',()=>{
 const rig=createRig(),z=joints.find(j=>j.id==='zSlide');
 for(const zSlide of [z.min,1.5175,z.max])for(const xSlide of [0,.30])for(const yaw of [-29,0,29]){
  applyState(rig,{...referenceState(),zSlide,xSlide,yaw});
  near(worldPosition(rig,'roll').y-GROUND_Y,2.3247+zSlide-1.5175,1e-12);
 }
 // 2 cm / 167.5 cm -> 827.2 / 2482.2 mm plumb COR height on a level base.
 near((2.3247+z.min-1.5175)*1000,827.2,1e-9);
 near((2.3247+z.max-1.5175)*1000,2482.2,1e-9);
});
test('WP coincides with COR at 195/160 and stays axial across slide/attitude boundaries',()=>{
 const rig=createRig(),cap=createTrussOutline();
 const range=id=>{const j=joints.find(j=>j.id===id);return [j.min,j.home,j.max];};
 for(const pitch of range('pitch'))for(const roll of range('roll'))for(const zSlide of range('zSlide')){
  const base={...referenceState(),pitch,roll,zSlide};applyState(rig,base);positionHolderCap(cap,rig);
  const cor=worldPosition(rig,'roll'),up=new Vector3(0,1,0).transformDirection(rig.nodes.roll.matrixWorld);
  near(cap.getWorldPosition(new Vector3()).distanceTo(cor),0,1e-12);
  for(const mastSlide of range('mastSlide'))for(const lowerCrowd of range('lowerCrowd')){
   applyState(rig,{...base,mastSlide,lowerCrowd});positionHolderCap(cap,rig);
   const offset=cap.getWorldPosition(new Vector3()).sub(cor);
   const axial=mastSlide-1.95+lowerCrowd-1.60;
   near(offset.dot(up),axial,1e-12);near(offset.clone().cross(up).length(),0,1e-12);
   near(worldPosition(rig,'roll').distanceTo(cor),0,1e-12);
  }
 }
});
test('pivot measurement uses full horizontal plane, signed plumb rise, and ordered inclination',()=>{
 const a=new Vector3(1,2,3),b=new Vector3(4,6,7),m=spanMeasurement(a,b),reverse=spanMeasurement(b,a);
 near(m.horizontal,5);near(m.vertical,4);near(m.length,Math.sqrt(41));
 near(m.angle,Math.atan2(4,5)*180/Math.PI);near(reverse.angle,-m.angle);near(reverse.vertical,-4);
});
