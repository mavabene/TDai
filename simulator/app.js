import * as T from 'three';
import {OrbitControls} from 'three/addons/controls/OrbitControls.js';
import {joints,referenceState,trackDefaultState,geometry as geometryConfig} from './config.js';
import {createEnvironment} from './environment.js';
import {createRig,applyState,advanceRotation} from './kinematics.js';
import {decorateRig} from './scene.js';
import {createOverlays} from './overlays.js';
import {createPointVisibility} from './movement-points.js';
import {crowdTopClearance,crowdCommandMaximum} from './crowd-geometry.js';
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
 const environment=createEnvironment(scene,ground);
 document.querySelector('#environment').onchange=e=>environment.setEnabled(e.target.checked);
 environment.setEnabled(document.querySelector('#environment').checked);
 const rig=createRig();scene.add(rig.root);const decor=decorateRig(rig,scene);
 const pointVisibility=createPointVisibility([...decor.pivots,...decor.slideSurfaces]);
 const overlays=createOverlays(scene,rig,decor);
 const pointsCheckbox=document.querySelector('#pivotPoints');
 pointVisibility.setShowAll(pointsCheckbox.checked,performance.now());
 pointsCheckbox.onchange=()=>{pointVisibility.setShowAll(pointsCheckbox.checked,performance.now());overlays.clearPivots();update();};
 const clear=document.createElement('button');clear.textContent='Clear pivot measurement';clear.onclick=()=>{overlays.clearPivots();update();};document.querySelector('.overlay-card').appendChild(clear);
 let state=referenceState(),selected=null;const inputs={};
 const rotaryAngles={lowerRotary:0,upperRotary:0};
 function update(){
  // Alignment/profile presets may raise LC while UC is already at its top.
  // Ordinary slider edits are limited at the edited axis, holding the other.
  const upperMax=crowdCommandMaximum('upperCrowd',state);
  if(state.upperCrowd>upperMax){state.upperCrowd=upperMax;if(inputs.upperCrowd)inputs.upperCrowd.number.value=inputs.upperCrowd.range.value=upperMax;}
  applyState(rig,{...state,...rotaryAngles});decor.updateCylinders();overlays.update(selected,state);
  pointVisibility.observe(state,performance.now());
  const crowdNote=document.querySelector('#crowd-note');
  if(crowdNote)crowdNote.textContent=`Bearing-block gap ${(state.upperCrowd*100).toFixed(1)} cm · drifter → rail top ${(crowdTopClearance(state)*100).toFixed(1)} cm. Live top limit keeps 5 cm clearance; zero gap is a model preview.`;
  for(const id of ['lowerCrowd','upperCrowd'])if(inputs[id]){
   const max=crowdCommandMaximum(id,state),{number,range}=inputs[id];
   number.max=range.max=max;
   range.parentElement.querySelector('.range-label span:last-child').textContent=`${max.toFixed(3)} m · ${id==='upperCrowd'?'coupled rail-top limit':'source max / rail-top limit'}`;
  }
  for(const id of ['mastSlide','lowerCrowd']){
   const note=document.querySelector(`#cor-note-${id}`);if(!note)continue;
   note.hidden=!document.querySelector('#etPlumb').checked;
   const other=id==='mastSlide'?'lowerCrowd':'mastSlide';
   const needed=geometryConfig.mastCOR+geometryConfig.lowerCrowdCOR-state[other];
   const range=joints.find(j=>j.id===id);
   const maximum=id==='lowerCrowd'?crowdCommandMaximum(id,state):range.max;
   note.textContent=`ET Plumb · reference ${((id==='mastSlide'?geometryConfig.mastCOR:geometryConfig.lowerCrowdCOR)*100).toFixed(0)} cm. To align WP with COR now: ${(needed*100).toFixed(1)} cm${needed<range.min-1e-9||needed>maximum+1e-9?' (outside this axis command range)':''}. Auto-set on mode entry; freely adjustable afterward.`;
  }
 }
 function select(id){selected=id;decor.highlight(id);overlays.update(selected,state);}
 document.querySelector('#dimensions').onchange=()=>overlays.update(selected,state);
 function alignHolder(){
   for(const [id,value] of [['mastSlide',geometryConfig.mastCOR],['lowerCrowd',geometryConfig.lowerCrowdCOR]]){
     state[id]=value;inputs[id].number.value=inputs[id].range.value=value;
   }
   update();
 }
 document.querySelector('#etPlumb').onchange=e=>e.target.checked?alignHolder():update();
 document.querySelector('#alignCap').onclick=alignHolder;
 let pointerStart;
 renderer.domElement.addEventListener('pointerdown',e=>{pointerStart=[e.clientX,e.clientY];});
 renderer.domElement.addEventListener('pointerup',e=>{
   if(e.button!==0)return;
   if(!pointerStart||Math.hypot(e.clientX-pointerStart[0],e.clientY-pointerStart[1])>5)return;
   const rect=renderer.domElement.getBoundingClientRect(),ray=new T.Raycaster();
   ray.setFromCamera(new T.Vector2((e.clientX-rect.left)/rect.width*2-1,-(e.clientY-rect.top)/rect.height*2+1),camera);
   if(document.querySelector('#dimensions').checked){
    const pivot=ray.intersectObjects(decor.pivots.filter(p=>p.visible),false)[0];
    if(pivot){overlays.selectPivot(pivot.object);update();return;}
   }
   const hits=ray.intersectObjects(decor.pickables,false);
   const hit=hits.find(h=>joints.some(j=>j.id===h.object.userData.joint));
   if(hit){document.querySelector('#dimensions').checked=true;select(hit.object.userData.joint);}
 });
 for(const j of joints){
   const row=document.createElement('div');row.className='joint';
   row.innerHTML=`<div class="joint-head"><label class="joint-name" for="range-${j.id}">${j.label}</label><div><input class="joint-value" id="value-${j.id}" aria-label="${j.label} value" type="number" min="${j.min}" max="${j.max}" step="${j.unit==='m'?.001:1}" value="${j.home}"><span class="joint-unit">${j.unit}</span></div></div><input id="range-${j.id}" aria-label="${j.label}" type="range" min="${j.min}" max="${j.max}" step="${j.unit==='m'?.001:1}" value="${j.home}"><div class="range-label"><span>${j.min} ${j.unit}</span><span>${j.max} ${j.unit} · ${j.rangeNote}</span></div><small>${j.hint}</small>`;
   const number=row.querySelector('[type=number]'),range=row.querySelector('[type=range]');inputs[j.id]={number,range};
   for(const input of [number,range]){
     input.addEventListener('focus',()=>select(j.id));
     input.addEventListener('input',()=>{if(input.value===''||!Number.isFinite(Number(input.value)))return;const max=['lowerCrowd','upperCrowd'].includes(j.id)?crowdCommandMaximum(j.id,state):j.max;state[j.id]=T.MathUtils.clamp(Number(input.value),j.min,max);number.value=range.value=state[j.id];select(j.id);update();});
     input.addEventListener('change',()=>{number.value=range.value=state[j.id];});
   }
   document.querySelector('#controls').appendChild(row);
   if(j.id==='upperCrowd'){
    const note=document.createElement('small');note.id='crowd-note';row.appendChild(note);
   }
   if(j.id==='mastSlide'||j.id==='lowerCrowd'){
    const note=document.createElement('small');note.id=`cor-note-${j.id}`;note.className='cor-note';note.hidden=true;row.appendChild(note);
   }
 }
 function setCamera(view='iso'){
   rig.root.updateMatrixWorld(true);const bounds=new T.Box3().setFromObject(rig.root).expandByObject(decor.scalePerson);const center=bounds.getCenter(new T.Vector3());
   const size=bounds.getSize(new T.Vector3());const radius=size.length()/2;
   const dist=radius/Math.sin(T.MathUtils.degToRad(camera.fov/2))/Math.min(1,camera.aspect)*1.12;
   const direction={iso:[-1,.42,1.3],side:[0,.04,1],end:[1,.03,0],top:[0,1,.001]}[view];
   camera.up.set(0,1,0);camera.position.copy(center).add(new T.Vector3(...direction).normalize().multiplyScalar(dist));orbit.target.copy(center);orbit.update();
   for(const b of document.querySelectorAll('[data-view]'))b.classList.toggle('active',b.dataset.view===view);
 }
 document.querySelectorAll('[data-view]').forEach(b=>b.addEventListener('click',()=>setCamera(b.dataset.view)));
 document.querySelector('#machineVersion').onchange=e=>{
   const j=joints.find(j=>j.id==='lowerCrowd');j.min=e.target.value==='0'?.44:.37;
   inputs[j.id].number.min=inputs[j.id].range.min=j.min;
   inputs[j.id].range.parentElement.querySelector('.range-label span').textContent=`${j.min} m`;
   state[j.id]=Math.max(j.min,state[j.id]);inputs[j.id].number.value=inputs[j.id].range.value=state[j.id];update();
 };
 document.querySelector('#fit').onclick=()=>setCamera(document.querySelector('[data-view].active')?.dataset.view||'iso');
 document.querySelector('#reset').onclick=()=>{state=referenceState();rotaryAngles.lowerRotary=rotaryAngles.upperRotary=0;for(const j of joints)inputs[j.id].number.value=inputs[j.id].range.value=state[j.id];decor.highlight(null);selected=null;update();};
 document.querySelector('#trackDefaults').onclick=()=>{state=trackDefaultState();rotaryAngles.lowerRotary=rotaryAngles.upperRotary=0;for(const j of joints)inputs[j.id].number.value=inputs[j.id].range.value=state[j.id];decor.highlight(null);selected=null;update();};
 document.querySelector('#stopRotaries').onclick=()=>{for(const id of ['lowerRotary','upperRotary']){state[id]=0;inputs[id].number.value=inputs[id].range.value=0;}};
 document.querySelector('#markers').onchange=e=>decor.axes.forEach(a=>a.visible=e.target.checked);
 const observer=new ResizeObserver(()=>{camera.aspect=pane.clientWidth/pane.clientHeight;camera.updateProjectionMatrix();renderer.setSize(pane.clientWidth,pane.clientHeight);});observer.observe(pane);
 camera.aspect=pane.clientWidth/pane.clientHeight;camera.updateProjectionMatrix();renderer.setSize(pane.clientWidth,pane.clientHeight);
 update();setCamera();
 let lastTime=performance.now();
 renderer.setAnimationLoop(()=>{
   const now=performance.now(),dt=Math.min(.05,(now-lastTime)/1000);lastTime=now;
   pointVisibility.refresh(now);
   for(const id of ['lowerRotary','upperRotary'])rotaryAngles[id]=advanceRotation(rotaryAngles[id],state[id],dt);
   if(state.lowerRotary||state.upperRotary)update();
   orbit.update();camera.updateMatrixWorld();overlays.draw(camera,pane.clientWidth,pane.clientHeight);renderer.render(scene,camera);
 });
 document.documentElement.dataset.modelStatus='ready';
}catch(e){const error=document.querySelector('#error');error.hidden=false;error.textContent=`Unable to start the 3D viewer: ${e.message}. Use a browser with WebGL enabled and launch through Launch Model.cmd.`;console.error(e);}
