// Dimension geometry lives in screen space, while the measurements remain world
// lengths/elevation angles. This keeps leaders legible as the camera moves.
export function layoutDimension(a,b,offset=38){
 const dx=b.x-a.x,dy=b.y-a.y,length=Math.hypot(dx,dy);
 const normal=length>1?{x:-dy/length,y:dx/length}:{x:1,y:0};
 const first={x:a.x+normal.x*offset,y:a.y+normal.y*offset};
 const second={x:b.x+normal.x*offset,y:b.y+normal.y*offset};
 let angle=Math.atan2(dy,dx)*180/Math.PI;if(angle>90)angle-=180;if(angle< -90)angle+=180;
 return {first,second,angle,center:{x:(first.x+second.x)/2,y:(first.y+second.y)/2}};
}
export function createCadDimensions(svg){
 const ns='http://www.w3.org/2000/svg';
 const make=(tag,attrs={})=>{const e=document.createElementNS(ns,tag);for(const [k,v]of Object.entries(attrs))e.setAttribute(k,v);return e;};
 const defs=make('defs');svg.appendChild(defs);
 for(const [key,color]of [['span','#a4510d'],['cor','#11666f'],['pin','#6255ad'],['pairH','#a4510d'],['pairV','#a4510d'],['pair','#a4510d']]){
  const marker=make('marker',{id:`arrow-${key}`,viewBox:'0 0 10 10',refX:'10',refY:'5',markerWidth:'7',markerHeight:'7',orient:'auto-start-reverse'});
  marker.appendChild(make('path',{d:'M 0 0 L 10 5 L 0 10 z',fill:color}));defs.appendChild(marker);
 }
 const entries=new Map();let measurements=[],snapshot='',lastDraw='';
 const segment=(element,a,b)=>{element.setAttribute('x1',a.x);element.setAttribute('y1',a.y);element.setAttribute('x2',b.x);element.setAttribute('y2',b.y);};
 return {set(items){
  const next=items.map(item=>[item.key,...item.a.toArray(),...item.b.toArray(),item.offset,item.label,item.sub].join('|')).join(';');
  if(next===snapshot)return;
  snapshot=next;measurements=items;svg.toggleAttribute('hidden',!items.length);
 },draw(camera,width,height){
  const view=[width,height,...camera.matrixWorld.elements,...camera.projectionMatrix.elements,snapshot].join('|');
  if(view===lastDraw)return;lastDraw=view;
  svg.setAttribute('viewBox',`0 0 ${width} ${height}`);
  const active=new Set();
  for(const item of measurements){
   active.add(item.key);let entry=entries.get(item.key);
   if(!entry){
    const group=make('g',{'class':`cad-dimension cad-${item.key}`});
    const leaders=[make('line',{'class':'cad-extension'}),make('line',{'class':'cad-extension'})];
    const line=make('line',{'marker-start':`url(#arrow-${item.key})`,'marker-end':`url(#arrow-${item.key})`});
    const label=make('text',{'text-anchor':'middle','class':'cad-label'}),sub=make('text',{'text-anchor':'middle','class':'cad-sub'});
    group.append(...leaders,line,label,sub);svg.appendChild(group);entry={group,leaders,line,label,sub};entries.set(item.key,entry);
   }
   const ndcA=item.a.clone().project(camera),ndcB=item.b.clone().project(camera);
   const inFront=[ndcA,ndcB].every(p=>p.z>=-1&&p.z<=1&&Number.isFinite(p.x));
   entry.group.style.display=inFront?'':'none';if(!inFront)continue;
   const a={x:(ndcA.x+1)*width/2,y:(1-ndcA.y)*height/2};
   const b={x:(ndcB.x+1)*width/2,y:(1-ndcB.y)*height/2};
   let layout=layoutDimension(a,b,item.offset);
   if(layout.center.x<70||layout.center.x>width-70)layout=layoutDimension(a,b,-item.offset);
   segment(entry.leaders[0],a,layout.first);segment(entry.leaders[1],b,layout.second);segment(entry.line,layout.first,layout.second);
   for(const [text,dy]of [[entry.label,-7],[entry.sub,15]])text.setAttribute('transform',`translate(${layout.center.x} ${layout.center.y}) rotate(${layout.angle}) translate(0 ${dy})`);
   entry.label.textContent=item.label;entry.sub.textContent=item.sub||'';
  }
  for(const [key,entry]of entries)if(!active.has(key))entry.group.style.display='none';
 }};
}
