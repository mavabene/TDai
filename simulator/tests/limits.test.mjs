import {test} from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {joints} from '../config.js';
import {advanceRotation} from '../kinematics.js';
test('position controls use active axesInit command limits, not feedback validity',async()=>{
 const path='../../Production_dev/TD3-Auto/exports_ojjo_TD3_cr711S_530v2/StandardPLC.dev/Plc Logic/Application/POUs/ACTUATORS/axesInit.pou';
 const source=(await readFile(new URL(path,import.meta.url),'utf8')).replace(/\(\*[\s\S]*?\*\)/g,'').replace(/\/\/[^\n]*/g,'');
 const axes={boomSwing:'BOOM_SWING',boomLift:'BOOM_LIFT',jointLift:'JOINT_LIFT',yaw:'YAW',xSlide:'X_SLIDE',pitch:'PITCH',zSlide:'Z_SLIDE',roll:'ROTATOR',mastSlide:'MAST_SLIDE',upperCrowd:'UPPER_CROWD'};
 for(const [id,axis] of Object.entries(axes)){
  const block=source.match(new RegExp(`pCONFIG := ADR\\(AXES\\[AXIS_${axis}\\]\\.CONFIG\\),([\\s\\S]*?)COMMAND_LIMIT_MIN := ([^,]+),`));
  assert.ok(block,axis);const max=Number(block[1].match(/COMMAND_LIMIT_MAX := ([^,]+)/)[1]),min=Number(block[2]);
  const j=joints.find(j=>j.id===id),scale=j.unit==='m'?.01:1;
  if(id==='upperCrowd'){assert.equal(min,1);assert.equal(j.min,0,'owner-requested touching-edge preview');}
  else assert.equal(j.min,min*scale,id);
  assert.ok(Math.abs(j.max-max*scale)<1e-12,id);assert.ok(j.home>=j.min&&j.home<=j.max);
 }
});
test('rotaries wrap through either direction without a position stop',()=>{
 assert.equal(advanceRotation(350,10,1),50);assert.equal(advanceRotation(-350,-10,1),-50);
 assert.equal(advanceRotation(30,0,10),30);
 let angle=0;for(let i=0;i<10000;i++)angle=advanceRotation(angle,25,.02);
 assert.ok(Number.isFinite(angle));assert.ok(Math.abs(angle)<360);
});
