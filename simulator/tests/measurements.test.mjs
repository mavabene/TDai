import {test} from 'node:test';
import assert from 'node:assert/strict';
import {Vector3} from 'three';
import {etGeometry,spanMeasurement,PIN_OFFSET,selectTrussSize,TRUSS_SIZES} from '../measurements.js';
const near=(a,b)=>assert.ok(Math.abs(a-b)<1e-10,`${a} != ${b}`);
test('length and elevation use world horizontal, including signed slope',()=>{
 const m=spanMeasurement(new Vector3(),new Vector3(3,4,0));near(m.length,5);near(m.angle,Math.atan2(4,3)*180/Math.PI);
 near(spanMeasurement(new Vector3(),new Vector3(0,-1,0)).angle,-90);
 near(spanMeasurement(new Vector3(),new Vector3(0,0,1)).angle,0);
});
test('ET chooses a listed stance, full stance twice half, fixed E/W symmetry',()=>{
 const g=etGeometry(new Vector3(-2,2,1),new Vector3(0,1,0),0);
 near(g.pinHeight,2+PIN_OFFSET);assert.ok(TRUSS_SIZES.some(row=>Math.abs(row.stance*.0254-g.stance)<1e-9));
 near(g.stance,2*g.half);near(g.east.y,g.reveal);near(g.east.z,-g.west.z);
 near(g.east.x,-2);near(g.west.x,-2);assert.ok(g.valid);
});
test('pin follows tilted cap but COR distance remains plumb',()=>{
 const g=etGeometry(new Vector3(1,2,0),new Vector3(Math.sin(Math.PI/3),Math.cos(Math.PI/3),0),0);
 near(g.corHeight,2);near(g.pinHeight,2+PIN_OFFSET*.5);assert.ok(g.pin.x>1);
});
test('out-of-table pin heights produce no screw markers',()=>{
 for(const height of [-1,0,.2286,4]){
 const g=etGeometry(new Vector3(0,height,0),new Vector3(0,1,0),0);
 assert.equal(g.valid,false);assert.equal(g.half,null);assert.equal(g.east,null);
 }
});
test('each listed row gives nine inch reveal at its midpoint pin height',()=>{
 for(const row of TRUSS_SIZES){const selected=selectTrussSize(row.minPinHeight+6);
 assert.equal(selected.size,row.size);near(selected.reveal,9);}
});
test('table minimum/maximum pin heights give 3/15 inch reveal; no extrapolation',()=>{
 near(selectTrussSize(40.93).reveal,3);near(selectTrussSize(114.94).reveal,15);
 assert.equal(selectTrussSize(40.92),null);assert.equal(selectTrussSize(114.95),null);
});
