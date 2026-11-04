import * as T from 'three';
import {geometry as g, joints, referenceState} from './config.js';
export const radians = d => d*Math.PI/180;
export const machineToRender = ([x,y,z]) => new T.Vector3(x,z,y);
export function createRig() {
  const root = new T.Group(); root.name='chassis';
  const nodes={chassis:root};
  function node(name,parent,x=0,y=0,z=0) {
    const n=new T.Group(); n.name=name; n.position.set(x,y,z);
    nodes[parent].add(n); nodes[name]=n; return n;
  }
  // Provisional pivot layout: swing -> boom lift -> joint lift -> yaw -> slide.
  // The two nominal horizontal projections remain 1.35 m each; vertical pivot
  // offsets are visual estimates. No automatic level compensation on movement.
  node('boomSwing','chassis',0,g.pivotHeight,0);
  node('boomLift','boomSwing');
  node('jointLift','boomLift',-g.arm,g.boomRise,0);
  node('yaw','jointLift',0,g.trunnionDrop,0);
  node('xSlide','yaw',-g.reach,0,0);
  node('pitch','xSlide');
  node('zSlide','pitch');
  node('roll','zSlide',0,g.rollHeight,0);
  node('mastSlide','roll',g.mastOffset,0,0);
  node('lowerCrowd','mastSlide',g.toolOffset,g.lowerHome,0);
  node('upperCrowd','lowerCrowd',0,g.upperSeparation,0);
  node('lowerRotary','lowerCrowd'); node('upperRotary','upperCrowd');
  const rig={root,nodes}; applyState(rig,referenceState()); return rig;
}
export function applyState({root,nodes:n},s) {
  for(const j of joints) if(!Number.isFinite(s[j.id])) throw Error(`Invalid joint: ${j.id}`);
  n.boomSwing.rotation.y=radians(s.boomSwing); // -X rotated positive Y -> +Z/right
  n.boomLift.rotation.z=-radians(s.boomLift);
  n.jointLift.rotation.z=radians(s.jointLift);
  n.yaw.rotation.y=-radians(s.yaw);
  n.xSlide.position.x=-g.reach-s.xSlide;
  n.pitch.rotation.z=radians(s.pitch);
  n.zSlide.position.y=s.zSlide;
  n.roll.rotation.x=radians(s.roll);
  n.mastSlide.position.y=s.mastSlide;
  n.lowerCrowd.position.y=g.lowerHome+s.lowerCrowd;
  n.upperCrowd.position.y=g.upperSeparation+s.upperCrowd;
  n.lowerRotary.rotation.y=radians(s.lowerRotary);
  n.upperRotary.rotation.y=radians(s.upperRotary);
  root.updateMatrixWorld(true);
}
export const worldPosition=(rig,name)=>rig.nodes[name].getWorldPosition(new T.Vector3());
