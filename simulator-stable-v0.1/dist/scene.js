import * as T from 'three';
import {geometry as g} from './config.js';
export function decorateRig(rig, scene) {
  const {nodes:n}=rig, pickables=[], axes=[], cylinders=[];
  const colors={red:0xc73d29,white:0xe3e9df,dark:0x283a3d,steel:0x879b98,track:0x303732};
  function mesh(parent,shape,color,pos=[0,0,0]) {
    const m=new T.Mesh(shape,new T.MeshStandardMaterial({color,roughness:.65,metalness:.22}));
    m.position.set(...pos);m.castShadow=true;m.receiveShadow=true;parent.add(m);
    m.userData.joint=parent.name;pickables.push(m);return m;
  }
  const box=(p,size,c,pos)=>mesh(p,new T.BoxGeometry(...size),c,pos);
  function rod(p,a,b,r,c) {
    const av=new T.Vector3(...a),bv=new T.Vector3(...b),d=bv.clone().sub(av);
    const m=mesh(p,new T.CylinderGeometry(r,r,d.length(),12),c,av.clone().add(bv).multiplyScalar(.5).toArray());
    m.quaternion.setFromUnitVectors(new T.Vector3(0,1,0),d.normalize());return m;
  }
  function anchor(parent,pos) {const p=new T.Object3D();p.position.set(...pos);parent.add(p);return p;}
  function cylinder(a,ap,b,bp) {
    const from=anchor(a,ap),to=anchor(b,bp);
    const body=mesh(scene,new T.CylinderGeometry(.075,.075,1,14),colors.white);
    const piston=mesh(scene,new T.CylinderGeometry(.034,.034,1,12),0xc6d2d1);
    cylinders.push({from,to,body,piston});
  }
  const red=colors.red,white=colors.white,dark=colors.dark,steel=colors.steel;
  box(n.chassis,[3.1,.3,1.7],dark,[.4,-.35,0]);
  box(n.chassis,[1.8,1.25,1.65],white,[1.05,.45,0]);
  box(n.chassis,[1.88,.10,1.73],red,[1.05,1.12,0]);
  box(n.chassis,[.55,1.05,1.71],red,[1.69,.45,0]);
  for (const z of [-.88,.88]) {
    // Rounded track belts with inset rollers, axis along render Z (machine Y).
    const shape=new T.Shape();shape.moveTo(-.8,-.37);shape.lineTo(.8,-.37);
    shape.absarc(.8,0,.37,-Math.PI/2,Math.PI/2,false);shape.lineTo(-.8,.37);
    shape.absarc(-.8,0,.37,Math.PI/2,Math.PI*1.5,false);
    const belt=mesh(n.chassis,new T.ExtrudeGeometry(shape,{depth:.34,bevelEnabled:false}),colors.track,[.2,-.69,z-.17]);
    for(let x=-.8;x<=.81;x+=.4){const wheel=mesh(n.chassis,new T.CylinderGeometry(.22,.22,.37,20),steel,[x+.2,-.72,z]);wheel.rotation.x=Math.PI/2;}
    for(let x=-.85;x<1.4;x+=.13)box(n.chassis,[.035,.04,.37],0x56605a,[x,-.31,z]);
  }
  rod(n.boomLift,[0,0,0],[-g.arm,g.boomRise,0],.14,red);
  box(n.jointLift,[.35,g.trunnionDrop,.5],red,[0,g.trunnionDrop/2,0]);
  // Separate rigid yaw reach and sliding horizontal guides.
  box(n.yaw,[g.reach,.15,.5],red,[-g.reach/2,0,0]);
  for(const z of [-.22,.22])box(n.yaw,[1.05,.09,.065],steel,[-.95,.14,z]);
  box(n.xSlide,[.65,.12,.6],red,[.2,.23,0]);
  // Pitch-supported red backbone; translating white member within its channel.
  for(const z of [-.19,.19])box(n.pitch,[.19,g.backboneHeight,.09],red,[.05,g.backboneHeight/2,z]);
  box(n.pitch,[.25,.12,.46],red,[.05,0,0]);
  box(n.zSlide,[.15,g.backboneHeight,.25],white,[0,g.backboneHeight/2+.18,0]);
  box(n.roll,[.55,.28,.65],dark,[-.14,0,0]);
  const ring=mesh(n.roll,new T.TorusGeometry(.26,.07,10,32),red);ring.rotation.y=Math.PI/2;
  // Red lattice mast and rear gray crowd guides.
  const bottom=g.mastBottom,top=bottom+g.mastLength;
  for(const x of [-.12,.12])for(const z of [-.24,.24])box(n.mastSlide,[.055,g.mastLength,.055],red,[x,(bottom+top)/2,z]);
  for(let y=bottom;y<top-.2;y+=.36){
    for(const z of [-.24,.24])rod(n.mastSlide,[-.12,y,z],[.12,Math.min(y+.36,top),z],.021,red);
    box(n.mastSlide,[.28,.035,.51],red,[0,y,0]);
  }
  for(const z of [-.29,.29])box(n.mastSlide,[.07,g.mastLength,.07],steel,[-.25,(bottom+top)/2,z]);
  for(const name of ['lowerCrowd','upperCrowd']){
    box(n[name],[.34,.38,.74],red,[.02,0,0]);
    for(const z of [-.32,.32])box(n[name],[.14,.58,.12],steel,[.1,0,z]);
  }
  // Tools share the same local axis; upper translation changes steel depth only.
  for(const name of ['lowerRotary','upperRotary']) {
    mesh(n[name],new T.CylinderGeometry(.19,.16,.3,12),dark,[0,-.23,0]);
    box(n[name],[.08,.28,.38],white,[.12,-.23,0]);
  }
  // Open hollow tube, not a solid cylinder obscuring the drill steel.
  mesh(n.lowerRotary,new T.CylinderGeometry(.09,.09,1.6,24,1,true),0xabbab0,[0,-1.18,0]);
  mesh(n.upperRotary,new T.CylinderGeometry(.029,.029,3.55,12),0x354e57,[0,-2.15,0]);
  for(let y=-.55;y>-1.95;y-=.18){const helix=mesh(n.lowerRotary,new T.TorusGeometry(.107,.016,5,24),steel,[0,y,0]);helix.rotation.x=Math.PI/2;}
  cylinder(n.boomSwing,[.05,-.38,.18],n.boomLift,[-1.05,.40,.18]);
  cylinder(n.boomLift,[-.12,.04,-.18],n.jointLift,[-.04,.48,-.18]);
  cylinder(n.xSlide,[.42,.30,.22],n.pitch,[.05,1.85,.22]);
  for(const [name,node] of Object.entries(n)){
    const a=new T.AxesHelper(.38);node.add(a);a.visible=false;axes.push(a);
  }
  function label(text,pos,color='#365d5b') {
    const canvas=document.createElement('canvas');canvas.width=512;canvas.height=64;
    const ctx=canvas.getContext('2d');ctx.font='bold 25px Segoe UI';ctx.fillStyle=color;ctx.fillText(text,10,42);
    const sprite=new T.Sprite(new T.SpriteMaterial({map:new T.CanvasTexture(canvas),depthTest:false}));sprite.position.set(...pos);sprite.scale.set(2,.25,1);scene.add(sprite);
  }
  label('+X  FORWARD',[3.5,-.88,0]);label('REAR / MAST',[-3.7,-.88,0]);label('+Y  RIGHT',[.4,-.88,2.2]);
  function updateCylinders(){
    rig.root.updateMatrixWorld(true);
    for(const c of cylinders){
      const a=c.from.getWorldPosition(new T.Vector3()),b=c.to.getWorldPosition(new T.Vector3());
      const d=b.clone().sub(a),length=d.length();
      for(const [part,start,end] of [[c.body,0,.57],[c.piston,.50,1]]){
        part.position.copy(a).addScaledVector(d,(start+end)/2);part.scale.y=Math.max(.001,length*(end-start));
        part.quaternion.setFromUnitVectors(new T.Vector3(0,1,0),d.clone().normalize());
      }
    }
  }
  return {axes,pickables,updateCylinders,highlight(name){
    for(const m of pickables){let p=m;let selected=false;while(p){if(p===n[name]){selected=true;break;}p=p.parent;}m.material.emissive.set(selected?0x422509:0);}
  }};
}
