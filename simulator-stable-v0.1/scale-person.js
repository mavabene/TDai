import * as T from 'three';
export const PERSON_HEIGHT=1.8288; // 6 ft exactly, ground to crown; no base pedestal.
export function createScalePerson(){
 const group=new T.Group();group.name='6-foot-scale-person';
 const material=new T.MeshStandardMaterial({color:0x42555a,roughness:1});
 function part(shape,x,y,z=0){const m=new T.Mesh(shape,material);m.position.set(x,y,z);m.castShadow=true;group.add(m);return m;}
 function limb(a,b,r){const start=new T.Vector3(...a),end=new T.Vector3(...b),d=end.clone().sub(start);
  const m=part(new T.CylinderGeometry(r,r,d.length(),10),...start.clone().add(end).multiplyScalar(.5).toArray());
  m.quaternion.setFromUnitVectors(new T.Vector3(0,1,0),d.normalize());
  part(new T.SphereGeometry(r,12,8),...a);part(new T.SphereGeometry(r,12,8),...b);
 }
 part(new T.SphereGeometry(.1488,24,16),0,1.68);
 limb([0,1.49,0],[0,1.55,0],.065);
 const torso=new T.Shape();torso.moveTo(-.20,1.48);torso.lineTo(.20,1.48);torso.lineTo(.14,.94);torso.lineTo(-.14,.94);torso.closePath();
 part(new T.ExtrudeGeometry(torso,{depth:.18,bevelEnabled:false}),0,0,-.09);
 for(const sign of [-1,1]){
  limb([sign*.19,1.40,0],[sign*.28,1.12,0],.055);
  limb([sign*.28,1.12,0],[sign*.31,.91,0],.047);
  limb([sign*.085,.96,0],[sign*.12,.51,0],.080);
  limb([sign*.12,.51,0],[sign*.15,.12,0],.063);
  part(new T.BoxGeometry(.145,.08,.27),sign*.15,.04,.055);
 }
 return group;
}
