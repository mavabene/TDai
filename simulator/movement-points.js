import * as T from 'three';
import {geometry as g} from './config.js';
export const MOVEMENT_POINTS=Object.freeze([
 ['boomSwing','Boom swing axis',[0,0,0]],
 ['boomLift','Boom lift pivot',[0,0,0]],
 ['jointLift','Joint lift pivot',[0,0,0]],
 ['yaw','Yaw axis',[0,0,0]],
 ['pitch','Pitch pivot',[0,0,0]],
 ['roll','Rotator COR',[0,0,0]],
 // Slides have no rotational pin: use a representative point on the carriage.
 // Offset X-slide from the coincident pitch axis so both can be picked.
 ['xSlide','X-slide carriage',[.20,.23,0]],
 ['zSlide','Z-slide carriage',[0,(g.rollHeight-.1+g.backboneHeight+.18)/2,0]],
 ['mastSlide','Mast slide reference',[0,0,0]],
 ['lowerCrowd','Lower crowd carriage',[.02,0,0]],
 ['upperCrowd','Upper crowd carriage',[.02,0,0]]
]);
export function createMovementPoints(rig){
 return MOVEMENT_POINTS.map(([id,name,position])=>{
  const point=new T.Mesh(new T.SphereGeometry(.065,16,12),
   new T.MeshStandardMaterial({color:0xe9b52f,roughness:.65,metalness:.22,depthTest:false}));
  point.position.set(...position);point.renderOrder=20;
  point.userData.joint=id;point.userData.pivotName=name;
  rig.nodes[id].add(point);return point;
 });
}
// Observe actual coordinate changes, including resets/alignment, not focus or
// mouse hover. Call refresh every frame so transient points expire while idle.
export function createPointVisibility(points,holdMs=2000){
 let showAll=true,previous=null;
 const until=new Map();
 const ids=point=>point.userData.movementJoints||[point.userData.joint];
 function refresh(now){for(const point of points)point.visible=showAll||ids(point).some(id=>now<(until.get(id)??-Infinity));}
 return {
  setShowAll(value,now){showAll=value;until.clear();refresh(now);},
  observe(state,now){
   if(previous)for(const point of points)for(const id of ids(point))if(state[id]!==previous[id])until.set(id,now+holdMs);
   previous={...state};refresh(now);
  },refresh
 };
}
