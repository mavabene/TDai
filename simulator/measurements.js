import * as T from 'three';
import {geometry as g} from './config.js';
import {drillTipLocalY} from './crowd-geometry.js';
export const GROUND_Y=-1.08;
export const PIN_OFFSET=.1016;
export const SCREW_REVEAL=9*.0254;
// Drawing: pin height at minimum (3 in) reveal, and full screw-axis stance, inches.
export const TRUSS_SIZES=Object.freeze([
 [40.93,20.22],[47.82,25.24],[54.71,30.25],[61.60,35.27],[68.49,40.28],
 [75.38,45.30],[82.27,50.32],[89.16,55.33],[96.05,60.35],[102.94,65.36]
].map(([minPinHeight,stance],index)=>Object.freeze({size:index+1,minPinHeight,stance})));
export function selectTrussSize(pinHeightInches){
 const candidates=TRUSS_SIZES.map(row=>({...row,reveal:3+pinHeightInches-row.minPinHeight}))
  .filter(row=>row.reveal>=3-1e-9&&row.reveal<=15+1e-9);
 candidates.sort((a,b)=>Math.abs(a.reveal-9)-Math.abs(b.reveal-9)||a.size-b.size);
 return candidates[0]||null;
}
export function spanMeasurement(a,b){
 const d=b.clone().sub(a);
 const horizontal=Math.hypot(d.x,d.z);
 return {length:d.length(),horizontal,vertical:d.y,angle:Math.atan2(d.y,horizontal)*180/Math.PI};
}
export function etGeometry(cor,capUp,ground=GROUND_Y,capWP=cor){
 const corHeight=cor.y-ground;
 const pin=capWP.clone().addScaledVector(capUp,PIN_OFFSET);
 const selected=selectTrussSize((pin.y-ground)/.0254);
 const valid=!!selected;
 const half=valid?selected.stance*.0254/2:null;
 const reveal=valid?selected.reveal*.0254:null;
 return {corHeight,pin,pinHeight:pin.y-ground,valid,half,stance:valid?2*half:null,selected,reveal,
  // North station follows COR; symmetry line is fixed at machine Y=0.
  east:valid?new T.Vector3(capWP.x,ground+reveal,half):null,
  west:valid?new T.Vector3(capWP.x,ground+reveal,-half):null};
}
export function measurementEndpoints(rig,id,cylinders){
 const n=rig.nodes,world=(node,p=[0,0,0])=>node.localToWorld(new T.Vector3(...p));
 const cylinder=cylinders.find(c=>c.joint===id);
 if(cylinder)return {a:world(cylinder.from),b:world(cylinder.to),description:'Cylinder pin to pin · estimated mounts'};
 if(id==='boomSwing')return {a:world(n.boomSwing),b:world(n.yaw),description:'Boom-swing pivot to yaw pivot · model 3D span'};
 if(id==='yaw')return {a:world(n.yaw),b:world(n.roll),description:'Yaw pivot to COR · current 3D span'};
 const slideZero={
  xSlide:[n.yaw,[-g.reach+g.pitchToRod,g.pitchRise,0]],
  zSlide:[n.pitch,[0,-.02,0]],
  mastSlide:[n.roll,[g.mastOffset,-g.mastCOR,0]],
  lowerCrowd:[n.mastSlide,[g.toolOffset,g.lowerHome-g.lowerCrowdCOR,0]],
  upperCrowd:[n.lowerCrowd,[0,g.upperSeparation,0]]
 }[id];
 if(slideZero)return {a:world(...slideZero),b:world(n[id]),description:'Slide travel from its zero reference'};
 if(id==='lowerRotary')return {a:world(n.lowerRotary,[0,g.chuckBottom,0]),b:world(n.lowerRotary,[0,g.chuckBottom-g.screwLength,0]),description:'Nominal screw length below chuck'};
 if(id==='upperRotary')return {a:world(n.upperRotary,[0,g.sledLength+g.drifterGap-.19,0]),b:world(n.upperRotary,[0,drillTipLocalY,0]),description:'Drill steel to tip · nominal flush calibration'};
 const node=n[id];
 if(!node)return null;
 const length=.5;
 return {a:world(node),b:world(node,[0,length,0]),description:'Local assembly-axis span · estimated geometry (not cylinder stroke)'};
}
