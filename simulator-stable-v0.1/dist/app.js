import * as T from 'three';
import {OrbitControls} from 'three/addons/controls/OrbitControls.js';
import {joints,referenceState} from './config.js';
import {createRig,applyState} from './kinematics.js';
import {decorateRig} from './scene.js';
const pane=document.querySelector('#viewport');
try {
 const scene=new T.Scene();scene.background=new T.Color(0xe9efed);
 const camera=new T.PerspectiveCamera(36,1,.05,150);
 const renderer=new T.WebGLRenderer({antialias:true,preserveDrawingBuffer:true});
 renderer.setPixelRatio(Math.min(devicePixelRatio,2));renderer.shadowMap.enabled=true;
 renderer.shadowMap.type=T.PCFSoftShadowMap;renderer.outputColorSpace=T.SRGBColorSpace;
 pane.appendChild(renderer.domElement);
 const orbit=new OrbitControls(camera,renderer.domElement);orbit.enableDamping=true;
 scene.add(new T.HemisphereLight(0xffffff,0x758b7b,2.4));
 const sun=new T.DirectionalLight(0xfff5df,3);sun.position.set(1,10,7);sun.castShadow=true;
 sun.shadow.mapSize.set(2048,2048);Object.assign(sun.shadow.camera,{left:-9,right:9,top:9,bottom:-9,far:35});sun.shadow.normalBias=.03;scene.add(sun);
 const ground=new T.Mesh(new T.PlaneGeometry(80,80),new T.MeshStandardMaterial({color:0xdce5df,roughness:1}));ground.rotation.x=-Math.PI/2;ground.position.y=-1.08;ground.receiveShadow=true;scene.add(ground);
 const grid=new T.GridHelper(30,60,0xb3c5bd,0xcbd7ce);grid.position.y=-1.075;scene.add(grid);
 const rig=createRig();scene.add(rig.root);const decor=decorateRig(rig,scene);
 let state=referenceState(),selected=null;const inputs={};
 function update(){applyState(rig,state);decor.updateCylinders();}
 function select(id){selected=id;decor.highlight(id);}
 for(const j of joints){
   const row=document.createElement('div');row.className='joint';
   row.innerHTML=`<div class="joint-head"><label class="joint-name" for="range-${j.id}">${j.label}</label><div><input class="joint-value" id="value-${j.id}" aria-label="${j.label} value" type="number" min="${j.min}" max="${j.max}" step="${j.unit==='m'?.01:1}" value="${j.home}"><span class="joint-unit">${j.unit}</span></div></div><input id="range-${j.id}" aria-label="${j.label}" type="range" min="${j.min}" max="${j.max}" step="${j.unit==='m'?.01:1}" value="${j.home}"><div class="range-label"><span>${j.min} ${j.unit}</span><span>${j.max} ${j.unit} · demo range</span></div><small>${j.hint}</small>`;
   const number=row.querySelector('[type=number]'),range=row.querySelector('[type=range]');inputs[j.id]={number,range};
   for(const input of [number,range]){
     input.addEventListener('focus',()=>select(j.id));
     input.addEventListener('input',()=>{if(input.value===''||!Number.isFinite(Number(input.value)))return;state[j.id]=T.MathUtils.clamp(Number(input.value),j.min,j.max);number.value=range.value=state[j.id];select(j.id);update();});
     input.addEventListener('change',()=>{number.value=range.value=state[j.id];});
   }
   document.querySelector('#controls').appendChild(row);
 }
 function setCamera(view='iso'){
   rig.root.updateMatrixWorld(true);const bounds=new T.Box3().setFromObject(rig.root);const center=bounds.getCenter(new T.Vector3());
   const size=bounds.getSize(new T.Vector3());const radius=size.length()/2;
   const dist=radius/Math.sin(T.MathUtils.degToRad(camera.fov/2))/Math.min(1,camera.aspect)*1.12;
   const direction={iso:[-1,.42,1.3],side:[0,.04,1],end:[1,.03,0],top:[0,1,.001]}[view];
   camera.up.set(0,1,0);camera.position.copy(center).add(new T.Vector3(...direction).normalize().multiplyScalar(dist));orbit.target.copy(center);orbit.update();
   for(const b of document.querySelectorAll('[data-view]'))b.classList.toggle('active',b.dataset.view===view);
 }
 document.querySelectorAll('[data-view]').forEach(b=>b.addEventListener('click',()=>setCamera(b.dataset.view)));
 document.querySelector('#fit').onclick=()=>setCamera(document.querySelector('[data-view].active')?.dataset.view||'iso');
 document.querySelector('#reset').onclick=()=>{state=referenceState();for(const j of joints)inputs[j.id].number.value=inputs[j.id].range.value=state[j.id];decor.highlight(null);selected=null;update();};
 document.querySelector('#markers').onchange=e=>decor.axes.forEach(a=>a.visible=e.target.checked);
 const observer=new ResizeObserver(()=>{camera.aspect=pane.clientWidth/pane.clientHeight;camera.updateProjectionMatrix();renderer.setSize(pane.clientWidth,pane.clientHeight);});observer.observe(pane);
 camera.aspect=pane.clientWidth/pane.clientHeight;camera.updateProjectionMatrix();renderer.setSize(pane.clientWidth,pane.clientHeight);
 update();setCamera();
 renderer.setAnimationLoop(()=>{orbit.update();renderer.render(scene,camera);});
}catch(e){const error=document.querySelector('#error');error.hidden=false;error.textContent=`Unable to start the 3D viewer: ${e.message}. Use a browser with WebGL enabled and launch through Launch Model.cmd.`;console.error(e);}
