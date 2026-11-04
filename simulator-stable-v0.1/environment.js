import * as T from 'three';
// Decorative only; ground height and the measurement grid remain unchanged.
export function createEnvironment(scene,ground){
 const scrub=new T.Group();scrub.name='Desert scrub';scene.add(scrub);
 const leaf=new T.MeshStandardMaterial({color:0x71884c,transparent:true,
  opacity:.25,depthWrite:false,roughness:1});
 const positions=[[-5,3.3],[-4,-3.2],[2.7,3.8],[4,-2.8],[.5,-4.4],[-6,-1.5]];
 for(const [x,z] of positions){
  const bush=new T.Group();bush.position.set(x,-1.08,z);scrub.add(bush);
  for(let i=0;i<5;i++){
   const angle=i*Math.PI*2/5;
   const tuft=new T.Mesh(new T.IcosahedronGeometry(1,1),leaf);
   tuft.position.set(Math.cos(angle)*.20,.24+(i%2)*.08,Math.sin(angle)*.20);
   tuft.scale.set(.30,.26+(i%2)*.10,.29);bush.add(tuft);
  }
 }
 return {scrub,setEnabled(enabled){scrub.visible=enabled;
  ground.material.color.setHex(enabled?0xe4d4b8:0xdce5df);
 }};
}
