import * as T from 'three';
import {geometry as g, joints, referenceState} from './config.js';
export const radians = d => d*Math.PI/180;
export const advanceRotation = (angle,rpm,seconds) => (angle+rpm*6*seconds)%360;
export const machineToRender = ([x,y,z]) => new T.Vector3(x,z,y);
export function createRig() {
  const root = new T.Group(); root.name='chassis';
  const nodes={chassis:root};
  function node(name,parent,x=0,y=0,z=0) {
    const n=new T.Group(); n.name=name; n.position.set(x,y,z);
    nodes[parent].add(n); nodes[name]=n; return n;
  }
  // Dimensioned reference: boom 25, joint 28 => level slide; link itself 29.6.
  node('boomSwing','chassis',0,g.pivotHeight,0);
  node('boomLift','boomSwing',-g.swingOffset);
  node('jointLift','boomLift',-g.arm,g.boomRise,0);
  node('yaw','jointLift',-g.jointYaw,0,0);
  node('xSlide','yaw',-g.reach+g.pitchToRod,g.pitchRise,0);
  node('pitch','xSlide');
  node('zSlide','pitch');
  node('roll','zSlide',-g.pitchToRod,g.rollHeight,0);
  node('mastSlide','roll',g.mastOffset,0,0);
  node('lowerCrowd','mastSlide',g.toolOffset,g.lowerHome,0);
  node('upperCrowd','lowerCrowd',0,g.upperSeparation,0);
  node('lowerRotary','lowerCrowd'); node('upperRotary','upperCrowd');
  node('pendulum','chassis',.29-g.swingOffset,g.pivotHeight-.423,0);
  const rig={root,nodes}; applyState(rig,referenceState()); return rig;
}
export function applyState({root,nodes:n},s) {
  for(const j of joints) if(!Number.isFinite(s[j.id])) throw Error(`Invalid joint: ${j.id}`);
  n.boomSwing.rotation.y=radians(s.boomSwing); // -X rotated positive Y -> +Z/right
  n.boomLift.rotation.z=-radians(s.boomLift);
  n.jointLift.rotation.z=radians(s.jointLift-3);
  n.yaw.rotation.y=-radians(s.yaw);
  n.xSlide.position.x=-g.reach+g.pitchToRod-s.xSlide;
  n.pitch.rotation.z=-radians(s.pitch);
  n.zSlide.position.y=s.zSlide-.02;
  n.roll.rotation.x=radians(s.roll);
  n.mastSlide.position.y=s.mastSlide-g.mastCOR;
  n.lowerCrowd.position.y=g.lowerHome+s.lowerCrowd-g.lowerCrowdCOR;
  // Source position is the clear gap between the bearing-block edges.
  n.upperCrowd.position.y=g.upperSeparation+s.upperCrowd;
  n.lowerRotary.rotation.y=radians(s.lowerRotary);
  n.upperRotary.rotation.y=radians(s.upperRotary);
  root.updateMatrixWorld(true);
}
export const worldPosition=(rig,name)=>rig.nodes[name].getWorldPosition(new T.Vector3());
