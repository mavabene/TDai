import * as T from 'three';
import {geometry as g,screwDiameter} from './config.js';
import {createScalePerson} from './scale-person.js';
import {createMovementPoints} from './movement-points.js';
import {drillTipLocalY} from './crowd-geometry.js';
export function decorateRig(rig, scene) {
  const {nodes:n}=rig, pickables=[], axes=[], cylinders=[],slideSurfaces=[];
  const gold=0xe9b52f;
  const colors={red:0x9f2929,white:0xe3e9df,dark:0x283a3d,steel:0x879b98,track:0x303732};
  function mesh(parent,shape,color,pos=[0,0,0]) {
    const m=new T.Mesh(shape,new T.MeshStandardMaterial({color,roughness:.65,metalness:.22}));
    m.position.set(...pos);m.castShadow=true;m.receiveShadow=true;parent.add(m);
    m.userData.joint=parent.name;pickables.push(m);return m;
  }
  const box=(p,size,c,pos)=>mesh(p,new T.BoxGeometry(...size),c,pos);
  function slideGuide(parent,size,pos,ids){
    // Keep the physical steel guide visible when its gold annotation is off.
    const base=box(parent,size,colors.steel,pos);base.userData.joint=ids[0];
    const highlight=box(parent,size.map(v=>v+.003),gold,pos);
    highlight.userData.joint=ids[0];highlight.userData.movementJoints=ids;
    slideSurfaces.push(highlight);
  }
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
    body.userData.joint=piston.userData.joint=b.name;
    cylinders.push({from,to,body,piston,joint:b.name});
  }
  const red=colors.red,white=colors.white,dark=colors.dark,steel=colors.steel;
  box(n.chassis,[3.55,.27,1.78],dark,[.55,-.32,0]);
  // Photo-inspired enclosure: long red body, front overhang, simple panel seams.
  box(n.chassis,[2.75,1.4,1.78],red,[1.12,.49,0]);
  box(n.chassis,[2.81,.08,1.84],red,[1.12,1.23,0]);
  for(const z of [-.901,.901]){
    box(n.chassis,[.018,1.20,.012],dark,[.86,.49,z]);
    box(n.chassis,[.018,1.20,.012],dark,[1.85,.49,z]);
    box(n.chassis,[.71,.49,.025],dark,[.33,.53,z]);
    // Sparse vent bars; enough to read as an equipment enclosure.
    for(let y=.15;y<.99;y+=.09)box(n.chassis,[.48,.015,.012],0x702329,[2.15,y,z]);
  }
  function logo(pos,rotation,width=1.15){
    const canvas=document.createElement('canvas');canvas.width=512;canvas.height=256;
    const ctx=canvas.getContext('2d');ctx.fillStyle='white';ctx.textAlign='center';
    ctx.font='bold 148px Arial';ctx.fillText('Ojjo',256,155);
    ctx.font='bold 23px Arial';ctx.fillText('TRUSS DRIVER',256,211);
    const texture=new T.CanvasTexture(canvas);texture.colorSpace=T.SRGBColorSpace;
    const plane=new T.Mesh(new T.PlaneGeometry(width,width/2),new T.MeshBasicMaterial({map:texture,transparent:true,depthWrite:false}));
    plane.position.set(...pos);plane.rotation.y=rotation;n.chassis.add(plane);
  }
  logo([1.34,.69,.905],0,.98);logo([1.34,.69,-.905],Math.PI,.98);
  logo([2.503,.59,0],Math.PI/2,1.15);
  // Large dark side-mounted cylinder and a spare drill-steel rack on the roof.
  const tank=mesh(n.chassis,new T.CylinderGeometry(.28,.28,1.22,24),dark,[-.73,.16,.86]);tank.rotation.z=Math.PI/2;
  for(const x of [-1.15,-.32])box(n.chassis,[.055,.30,.48],red,[x,-.1,.85]);
  for(const z of [-.48,-.32,-.16,0,.16,.32,.48]){
    const steelTube=mesh(n.chassis,new T.CylinderGeometry(.045,.045,1.15,8),dark,[1.8,1.38,z]);steelTube.rotation.z=Math.PI/2;
  }
  for (const z of [-.925,.925]) {
    // Rounded track belts with inset rollers, axis along render Z (machine Y).
    const radius=.6647/2,cy=-1.08+radius;
    const shape=new T.Shape();shape.moveTo(-.98,-radius);shape.lineTo(.98,-radius);
    shape.absarc(.98,0,radius,-Math.PI/2,Math.PI/2,false);shape.lineTo(-.98,radius);
    shape.absarc(-.98,0,radius,Math.PI/2,Math.PI*1.5,false);
    mesh(n.chassis,new T.ExtrudeGeometry(shape,{depth:.40,bevelEnabled:false}),colors.track,[0,cy,z-.20]);
    for(let x=-.96;x<=.97;x+=.32){const wheel=mesh(n.chassis,new T.CylinderGeometry(.24,.24,.43,20),0x555e58,[x,-.70,z]);wheel.rotation.x=Math.PI/2;}
    for(let x=-1.0;x<1.05;x+=.12)for(const y of [cy+radius-.0175,-1.08+.0175])box(n.chassis,[.055,.035,.40],0x626a61,[x,y,z]);
  }
  for(const z of [-.20,.20])rod(n.boomLift,[0,0,z],[-g.arm,g.boomRise,z],.115,red);
  rod(n.jointLift,[0,0,0],[-g.jointYaw,0,0],.13,red);
  // Separate rigid yaw reach and sliding horizontal guides.
  const yawToPitch=g.reach-g.pitchToRod;
  box(n.yaw,[yawToPitch+.3,.15,.5],red,[-yawToPitch/2,0,0]);
  rod(n.yaw,[0,0,0],[-yawToPitch,g.pitchRise,0],.09,red);
  for(const z of [-.22,.22])slideGuide(n.yaw,[.68,.09,.065],[-yawToPitch/2,g.pitchRise-.12,z],['xSlide']);
  box(n.xSlide,[.65,.12,.6],red,[.2,.23,0]);
  // Pitch-supported red backbone; translating white member within its channel.
  for(const z of [-.19,.19])box(n.pitch,[.19,g.backboneHeight,.09],red,[.05,g.backboneHeight/2,z]);
  box(n.pitch,[.25,.12,.46],red,[.05,0,0]);
  // Carry the rotator at the drawing-derived bottom of the moving member;
  // the former short white block left its lower support floating in space.
  const movingBottom=g.rollHeight-.1,movingTop=g.backboneHeight+.18;
  box(n.zSlide,[.15,movingTop-movingBottom,.25],white,[0,(movingBottom+movingTop)/2,0]);
  for(const z of [-.14,.14])slideGuide(n.pitch,[.17,g.backboneHeight,.025],[0,g.backboneHeight/2,z],['zSlide']);
  box(n.roll,[.55,.28,.65],dark,[-.14,0,0]);
  // Connect the white Z carriage to the offset drill-line rotator.
  box(n.zSlide,[g.pitchToRod,.15,.48],red,[-g.pitchToRod/2,g.rollHeight,0]);
  const ring=mesh(n.roll,new T.TorusGeometry(.26,.07,10,32),red);ring.rotation.y=Math.PI/2;
  // Red lattice mast and rear gray crowd guides.
  const bottom=g.mastBottom,top=g.mastTop;
  box(n.mastSlide,[.34,.08,.60],red,[0,top+.04,0]);
  // Photo reference: black antenna arms belong to the translating Z-slide,
  // not the independently sliding/rolling mast. Arm shape/spacing are schematic.
  const antennaHeight=g.backboneHeight+.18;
  for(const side of [-1,1]){
    rod(n.zSlide,[0,antennaHeight-.20,side*.12],[0,antennaHeight+.10,side*.48],.035,dark);
    rod(n.zSlide,[0,antennaHeight+.10,side*.48],[0,antennaHeight+.15,side*.95],.035,dark);
    rod(n.zSlide,[0,antennaHeight-.42,side*.12],[0,antennaHeight+.10,side*.48],.018,dark);
    rod(n.zSlide,[0,antennaHeight+.15,side*.95],[0,antennaHeight+.22,side*.95],.018,dark);
    const antenna=mesh(n.zSlide,new T.CylinderGeometry(.085,.09,.035,24),dark,[0,antennaHeight+.24,side*.95]);
    antenna.name=`GPS antenna ${side<0?'west':'east'}`;
  }
  for(const x of [-.12,.12])for(const z of [-.24,.24])box(n.mastSlide,[.055,g.mastLength,.055],red,[x,(bottom+top)/2,z]);
  for(let y=bottom;y<top-.2;y+=.36){
    for(const z of [-.24,.24])rod(n.mastSlide,[-.12,y,z],[.12,Math.min(y+.36,top),z],.021,red);
    box(n.mastSlide,[.28,.035,.51],red,[0,y,0]);
  }
  for(const z of [-.29,.29])slideGuide(n.mastSlide,[.07,g.mastRailLength,.07],[-.25,g.mastRailBottom+g.mastRailLength/2,z],['lowerCrowd','upperCrowd']);
  for(const z of [-.25,.25])slideGuide(n.roll,[.04,.48,.08],[g.mastOffset,0,z],['mastSlide']);
  box(n.mastSlide,[.30,g.centralizerThickness,g.centralizerWidth],dark,[g.toolOffset,bottom+g.centralizerThickness/2,0]);
  for(const name of ['lowerCrowd','upperCrowd']){
    box(n[name],[.34,g.sledLength,.74],red,[.02,0,0]);
    for(const z of [-.32,.32])slideGuide(n[name],[.14,g.sledLength,.12],[.1,0,z],[name]);
  }
  // Source's third sled belongs to the drifter above the upper-crowd sled.
  const drifterY=g.sledLength+g.drifterGap;
  box(n.upperCrowd,[.30,g.sledLength,.58],red,[.02,drifterY,0]);
  for(const z of [-.27,.27])slideGuide(n.upperCrowd,[.12,g.sledLength,.10],[.1,drifterY,z],['upperCrowd']);
  for(const z of [-.22,.22])rod(n.upperCrowd,[.10,g.sledLength/2,z],[.10,drifterY-g.sledLength/2,z],.025,steel);
  // Schematic cap-holder stand. Its seat meets the cap's lower outline; mount
  // dimensions are estimates, while COR alignment uses the source reference pose.
  box(n.lowerCrowd,[.25,.04,.40],dark,[0,-g.lowerHome-.22,0]);
  for(const z of [-.16,.16])rod(n.lowerCrowd,[.14,-g.sledLength/2,z],[.14,-g.lowerHome-.22,z],.025,steel);
  // Tools share the same local axis; upper translation changes steel depth only.
  const lowerHousingHeight=.632,lowerHousingY=g.chuckBottom+lowerHousingHeight/2;
  mesh(n.lowerRotary,new T.CylinderGeometry(.19,.16,lowerHousingHeight,12),dark,[0,lowerHousingY,0]);
  box(n.lowerRotary,[.08,.28,.38],white,[.12,lowerHousingY,0]);
  mesh(n.upperRotary,new T.CylinderGeometry(.15,.13,.38,12),dark,[0,drifterY,0]);
  box(n.upperRotary,[.08,.28,.30],white,[.12,drifterY,0]);
  // Open hollow tube, not a solid cylinder obscuring the drill steel.
  mesh(n.lowerRotary,new T.CylinderGeometry(screwDiameter/2,screwDiameter/2,g.screwLength,24,1,true),0xabbab0,[0,g.chuckBottom-g.screwLength/2,0]);
  const steelBottom=drillTipLocalY,steelTop=drifterY-.19;
  mesh(n.upperRotary,new T.CylinderGeometry(.029,.029,steelTop-steelBottom,12),0x354e57,[0,(steelTop+steelBottom)/2,0]);
  for(let y=g.chuckBottom-.18;y>g.chuckBottom-g.screwLength+.05;y-=.18){const helix=mesh(n.lowerRotary,new T.TorusGeometry(screwDiameter/2-.006,.006,5,24),steel,[0,y,0]);helix.rotation.x=Math.PI/2;}
  cylinder(n.boomSwing,[.05,-.38,.18],n.boomLift,[-1.05,.40,.18]);
  cylinder(n.boomLift,[-.12,.04,-.18],n.jointLift,[-.04,.48,-.18]);
  cylinder(n.xSlide,[.42,.30,.22],n.pitch,[.05,1.85,.22]);
  const pivots=createMovementPoints(rig);
  for(const point of pivots){
    const node=point.parent;
    const a=new T.AxesHelper(.38);node.add(a);a.visible=false;axes.push(a);
  }
  function label(text,pos,color='#365d5b') {
    const canvas=document.createElement('canvas');canvas.width=512;canvas.height=64;
    const ctx=canvas.getContext('2d');ctx.font='bold 25px Segoe UI';ctx.fillStyle=color;ctx.fillText(text,10,42);
    const sprite=new T.Sprite(new T.SpriteMaterial({map:new T.CanvasTexture(canvas),depthTest:false}));sprite.position.set(...pos);sprite.scale.set(2,.25,1);scene.add(sprite);
  }
  label('NORTH / +X',[3.5,-.88,0]);label('SOUTH / REAR',[-3.7,-.88,0]);label('EAST / +Y',[.4,-.88,2.2]);label('WEST / -Y',[.4,-.88,-2.2]);
  const scalePerson=createScalePerson();scalePerson.position.set(-.8,-1.08,2.3);scalePerson.rotation.y=-.35;scene.add(scalePerson);
  label('6 FT / 1.8288 M',[-.8,-.96,2.7]);
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
  return {axes,pickables,pivots,slideSurfaces,cylinders,scalePerson,updateCylinders,highlight(name){
    for(const m of pickables){let p=m;let selected=false;while(p){if(p===n[name]){selected=true;break;}p=p.parent;}m.material.emissive.set(selected?0x422509:0);}
  }};
}
