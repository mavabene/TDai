import * as T from 'three';
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
 return {length:d.length(),angle:Math.atan2(d.y,Math.hypot(d.x,d.z))*180/Math.PI};
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
 if(id==='xSlide')return {a:world(n.yaw),b:world(n.xSlide),description:'Yaw pivot to X-slide/pitch origin'};
 const node=n[id];
 if(!node)return null;
 const length={zSlide:2.1,mastSlide:6.2,lowerCrowd:.58,upperCrowd:.58,lowerRotary:1.6,upperRotary:3.55,roll:.5}[id]||.5;
 return {a:world(node),b:world(node,[0,length,0]),description:'Local assembly-axis span · estimated geometry (not cylinder stroke)'};
}
