import * as T from 'three';
import {geometry as g} from './config.js';
// Schematic outline, local WP at origin. Y is cap-up, Z is East/West.
// Lobes/socket positions are visual estimates, not fabrication geometry.
export const CAP_SOCKETS=[new T.Vector3(0,-.22,-.105),new T.Vector3(0,-.22,.105)];
export function positionHolderCap(cap,rig){
 if(cap.parent!==rig.nodes.lowerCrowd)rig.nodes.lowerCrowd.add(cap);
 cap.position.set(0,-g.lowerHome,0);cap.quaternion.identity();
 rig.root.updateMatrixWorld(true);
 cap.updateMatrixWorld(true);
}
export function createTrussOutline(){
 const group=new T.Group();group.name='ET-cap-outline';
 const shapePoints=[[0,.12],[-.08,.18],[-.17,.16],[-.21,.07],[-.18,-.07],[-.105,-.22],
  [.105,-.22],[.18,-.07],[.21,.07],[.17,.16],[.08,.18],[0,.12]];
 const curve=new T.CatmullRomCurve3(shapePoints.map(([z,y])=>new T.Vector3(0,y,z)),true);
 const body=new T.Mesh(new T.TubeGeometry(curve,64,.016,8,true),new T.MeshStandardMaterial({color:0xf2e4bc,roughness:.6}));group.add(body);
 const wp=new T.Mesh(new T.SphereGeometry(.025),new T.MeshBasicMaterial({color:0x32b9c4}));group.add(wp);
 const pin=new T.Mesh(new T.TorusGeometry(.035,.008,8,24),new T.MeshStandardMaterial({color:0x8d7ac1}));pin.rotation.y=Math.PI/2;pin.position.y=.1016;group.add(pin);
 const socketMaterial=new T.MeshStandardMaterial({color:0xe4d6b2});
 for(const p of CAP_SOCKETS){const socket=new T.Mesh(new T.CylinderGeometry(.035,.035,.12,12,1,true),socketMaterial);socket.position.copy(p);socket.rotation.x=p.z<0?-Math.PI/9:Math.PI/9;group.add(socket);}
 return group;
}
