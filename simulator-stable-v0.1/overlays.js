import * as T from 'three';
import {joints,screwDiameter} from './config.js';
import {GROUND_Y,etGeometry,measurementEndpoints,spanMeasurement} from './measurements.js';
import {createTrussOutline,CAP_SOCKETS,positionHolderCap} from './truss-outline.js';
import {createCadDimensions} from './cad-dimensions.js';
export function createOverlays(scene,rig,decor){
 const dimensionGroup=new T.Group(),etGroup=new T.Group();scene.add(dimensionGroup,etGroup);
 function line(parent,color){const l=new T.Line(new T.BufferGeometry().setFromPoints([new T.Vector3(),new T.Vector3()]),new T.LineBasicMaterial({color,depthTest:false}));l.renderOrder=10;parent.add(l);return l;}
 function setLine(l,a,b){const array=l.geometry.attributes.position;array.setXYZ(0,...a.toArray());array.setXYZ(1,...b.toArray());array.needsUpdate=true;l.geometry.computeBoundingSphere();}
 const corLine=line(dimensionGroup,0x19727c),selectedLine=line(dimensionGroup,0xe07724),pinLine=line(dimensionGroup,0x6375b7);
 const stanceLine=line(etGroup,0xa85b15),centerLine=line(etGroup,0x657a87);
 const cap=createTrussOutline();positionHolderCap(cap,rig);
 cap.traverse(object=>{if(object.isMesh){object.material.transparent=true;object.material.opacity=.85;object.material.depthTest=false;object.renderOrder=12;}});
 const assembledLegs=CAP_SOCKETS.map(()=>{
  const geometry=new T.BufferGeometry().setFromPoints([new T.Vector3(),new T.Vector3(),new T.Vector3(),new T.Vector3()]);
  const outline=new T.Line(geometry,new T.LineBasicMaterial({color:0xc58b29,depthTest:false}));outline.renderOrder=11;etGroup.add(outline);return outline;
 });
 const corMarker=new T.Mesh(new T.SphereGeometry(.055),new T.MeshBasicMaterial({color:0x167e87}));dimensionGroup.add(corMarker);
 const pinMarker=new T.Mesh(new T.SphereGeometry(.04),new T.MeshBasicMaterial({color:0x6a63c7}));dimensionGroup.add(pinMarker);
 const screws=[];
 for(const sign of [-1,1]){
  const screw=new T.Group();etGroup.add(screw);
  const mat=new T.MeshStandardMaterial({color:0xe1a34a,metalness:.5,roughness:.5});
  const tube=new T.Mesh(new T.CylinderGeometry(screwDiameter/2,screwDiameter/2,.35,24,1,true),mat);tube.position.y=-.175;screw.add(tube);
  const rim=new T.Mesh(new T.TorusGeometry(screwDiameter/2-.004,.004,8,24),mat);rim.rotation.x=Math.PI/2;screw.add(rim);
  // ET Plumb screw ends are world-vertical; the inclined upper members bend
  // onto these ends. Do not apply the old battered-screw orientation here.
  screws.push(screw);
 }
 const detail=document.querySelector('#measurementReadout'),etText=document.querySelector('#etReadout');
 const dimensions=document.querySelector('#dimensions'),et=document.querySelector('#etPlumb');
 const cad=createCadDimensions(document.querySelector('#cadDimensions'));
 return {draw:cad.draw,update(selected,state){
  rig.root.updateMatrixWorld(true);
  const cor=rig.nodes.roll.getWorldPosition(new T.Vector3());
  positionHolderCap(cap,rig);
  const capWP=cap.getWorldPosition(new T.Vector3());
  const capUp=new T.Vector3(0,1,0).transformDirection(cap.matrixWorld);
  const alignment=cor.distanceTo(capWP);
  const result=etGeometry(cor,capUp,GROUND_Y,capWP);
  const annotations=[];
  dimensionGroup.visible=dimensions.checked;detail.hidden=!dimensions.checked;
  if(dimensions.checked){
   setLine(corLine,cor,new T.Vector3(cor.x,GROUND_Y,cor.z));corMarker.position.copy(cor);
   setLine(pinLine,result.pin,new T.Vector3(result.pin.x,GROUND_Y,result.pin.z));pinMarker.position.copy(result.pin);
   annotations.push({key:'cor',a:cor,b:new T.Vector3(cor.x,GROUND_Y,cor.z),offset:-48,label:`COR ${(result.corHeight*100).toFixed(1)} cm`,sub:'plumb to ground'});
   annotations.push({key:'pin',a:result.pin,b:new T.Vector3(result.pin.x,GROUND_Y,result.pin.z),offset:48,label:`PIN ${(result.pinHeight*100).toFixed(1)} cm`,sub:'plumb to ground'});
   const ends=measurementEndpoints(rig,selected,decor.cylinders);selectedLine.visible=!!ends;
   let text=`COR → ground (plumb): ${(result.corHeight*100).toFixed(1)} cm\nPin → ground (plumb): ${(result.pinHeight*100).toFixed(1)} cm`;
   if(ends){const measure=spanMeasurement(ends.a,ends.b);setLine(selectedLine,ends.a,ends.b);const joint=joints.find(j=>j.id===selected);
    const kind=ends.description.startsWith('Cylinder')?'pin-to-pin':'model span';
    const travel=joint.unit==='m'?` · travel ${(state[selected]*100).toFixed(1)} cm`:'';
    annotations.push({key:'span',a:ends.a,b:ends.b,offset:40,label:`${joint.label} · ${(measure.length*100).toFixed(1)} cm`,sub:`${measure.angle.toFixed(1)}° horizontal · ${kind}${travel}`});
    text+=`\n\n${joint.label}\n${ends.description}\nLength: ${(measure.length*100).toFixed(1)} cm\nElevation from world horizontal: ${measure.angle.toFixed(1)}°`;
    if(joint.unit==='m')text+=`\nTravel position: ${(state[selected]*100).toFixed(1)} cm`;
   }else text+='\n\nClick an actuator on the model, or focus its control.';
   detail.textContent=text;
   detail.textContent=`COR ${ (result.corHeight*100).toFixed(1)} cm · Pin ${(result.pinHeight*100).toFixed(1)} cm`;
   detail.title=text;
  }
  cad.set(annotations);
  etGroup.visible=et.checked;etText.hidden=!et.checked;
  cap.visible=et.checked;
  for(const object of [...screws,...assembledLegs,stanceLine,centerLine])object.visible=result.valid;
  if(et.checked){
   etText.textContent=result.valid?`ET PLUMB · vertical screw ends\nEach side from N–S centerline: ${(result.half/.0254).toFixed(3)} in\nFull screw-to-screw stance: ${(result.stance/.0254).toFixed(2)} in\nDrawing row: ${result.selected?.size} / 10\nScrew reveal: ${(result.reveal/.0254).toFixed(2)} in (3–15 allowable)\nCOR height: ${(result.corHeight*100).toFixed(1)} cm\nPin height: ${(result.pinHeight*100).toFixed(1)} cm\nEast +Y / West −Y · forward = North\nNo automatic screw-placement sequence.`:'ET PLUMB: no listed size fits this pin height with 3–15 inch reveal (drawing pin-height envelope 40.93–114.94 in).';
   if(result.valid){
    // Cap is mounted on the lower crowd. At the source assembly reference
    // positions its WP coincides with COR; it is not held there during travel.
    [result.west,result.east].forEach((top,index)=>{
     const socket=cap.localToWorld(CAP_SOCKETS[index].clone());
     const upperBend=top.clone().add(new T.Vector3(0,.20,0));
     const lowerBend=top.clone().add(new T.Vector3(0,.08,0));
     const points=[socket,upperBend,lowerBend,top];
     const attribute=assembledLegs[index].geometry.attributes.position;
     points.forEach((p,i)=>attribute.setXYZ(i,p.x,p.y,p.z));attribute.needsUpdate=true;
     assembledLegs[index].geometry.computeBoundingSphere();
    });
    etText.textContent+=`\nCap mounted on lower-crowd holder.\nWP → COR separation: ${(alignment*100).toFixed(2)} cm\nAssembly reference: mast 195 cm / lower crowd 160 cm.\nLeg/bend outlines are schematic, not fit validation.`;
    if(Math.abs(capWP.z)>.001)etText.textContent+='\nCap WP is off the N–S line. Markers remain symmetric about the chassis line; these are screw-placement targets, not the current drill axis.';
    screws[0].position.copy(result.west);screws[1].position.copy(result.east);setLine(stanceLine,result.west,result.east);setLine(centerLine,new T.Vector3(-6,GROUND_Y+.01,0),new T.Vector3(6,GROUND_Y+.01,0));
   }
   const verbose=etText.textContent;
   etText.textContent=result.valid?`ET Plumb · size ${result.selected.size}/10\nStance ${(result.stance/.0254).toFixed(2)} in · each ${(result.half/.0254).toFixed(3)} in\nReveal ${(result.reveal/.0254).toFixed(2)} in · pin ${(result.pinHeight*100).toFixed(1)} cm\nWP ↔ COR ${(alignment*100).toFixed(1)} cm${Math.abs(capWP.z)>.001?'\nCap WP is off the N–S centerline.':''}`:`ET Plumb · no fitting size\nPin ${(result.pinHeight/.0254).toFixed(2)} in\nDrawing range: 40.93–114.94 in`;
   etText.title=verbose;
  }
 }};
}
