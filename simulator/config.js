// Model configuration v0.1. Dimensions in metres; UI rotations in degrees.
// Command ranges: PLC 530v2 axesInit; lower crowd also uses machineInit.
// Geometry and encoder-to-drawing zero offsets remain visual estimates.
// Close the owner's COR height using drawing heights, rather than the rounded
// 29.6-degree label. Preserve the measured link span and parallel-axis spacing.
const boomLink=1.1838;
const boomReferenceAngle=Math.asin((2.3247-.865-.8404-.0345)/boomLink);
const boomDrawingZero=boomReferenceAngle-25*Math.PI/180;
// 530v2 updateCalculatedDimensions + machineInit (family 3, version 2).
// Anchor the centralizer to the owner's drawing COR, not the older 87 cm
// nominal rotator height. The source centralizer formula gives -12 cm at
// Z=2 cm / mast=197.5 cm; the drawing gives COR=82.72 cm at that Z.
const centralizerBottom=-.12-(2.3247+.02-1.5175)-(1.975-1.95);
const centralizerTop=centralizerBottom+.16;
const sledLength=18.7*.0254,drifterGap=5.125*.0254;
const railLength=278*.0254,railBaseHousing=11*.0254;
const mastTop=centralizerTop+railBaseHousing+railLength;
const lowerHome=centralizerTop+1.60+sledLength/2;
const chuckBottom=-sledLength/2-.632;
export const geometry = Object.freeze({
  revision: 'TD3 working model 0.4 source crowd datums',
  arm: boomLink*Math.cos(boomDrawingZero),
  boomRise: boomLink*Math.sin(boomDrawingZero),
  swingOffset: 1.42929445384-(boomLink*Math.cos(boomReferenceAngle)+.23),
  jointYaw: .23, reach: 1.2232, pitchRise:.8404,
  trunnionDrop: 0, pivotHeight: -.215,
  backboneHeight: 2.1, rollHeight: .0345-(1.5175-.02),
  mastBottom:centralizerBottom,mastTop,mastLength:mastTop-centralizerBottom,
  mastRailBottom:centralizerTop+railBaseHousing,mastRailLength:railLength,
  centralizerTop,sledLength,drifterGap,lowerHome,upperSeparation:sledLength,
  chuckBottom,drillBelowChuckAtUpperZero:2.068,
  screwLength:2, // nominal first sPersistent_1 screw; not a loaded product selection
  // Owner's dimensioned drawing supersedes the earlier source nominal offset.
  pitchToRod: .9332, centralizerWidth: .62, centralizerThickness: .16,
  mastOffset: .25, toolOffset: -.25,
  mastCOR: 1.95, lowerCrowdCOR: 1.60 // source constant and persistent declaration default
});
export const joints = [
  ['boomSwing','Boom swing',-27,27,0,'°','Positive feedback → arm swings right'],
  ['boomLift','Boom lift',-18,30,25,'°','Increasing → boom pivots upward'],
  ['jointLift','Joint lift',-12,30,28,'°','Increasing → trunnion tilts rearward'],
  ['yaw','Yaw',-29,29,0,'°','Positive feedback → arm swings left'],
  ['xSlide','X-slide',0,.30,0,'m','Increasing → longer rearward reach'],
  ['pitch','Pitch',-6,80,0,'°','Direction corrected by owner · drawing zero estimated'],
  ['zSlide','Z-slide',.02,1.675,1.5175,'m','Drawing reference: 151.75 cm · carries downstream assembly'],
  ['roll','Rotator / roll',-38,38,0,'°','Mast rolls; backbone stays fixed'],
  ['mastSlide','Mast slide',0,1.975,1.95,'m','COR reference 195 cm · whole mast and crowds translate'],
  ['lowerCrowd','Lower crowd',.37,2.70,1.60,'m','COR reference 160 cm · source default, adjustable on rig'],
  ['upperCrowd','Upper crowd · relative',0,3,0,'m','Bearing-block edge gap · 0 = stacked (source command minimum 1 cm)'],
  ['lowerRotary','Lower rotary speed',-60,60,0,'rpm','Continuous ground-screw rotation · ± direction'],
  ['upperRotary','Upper rotary speed',-200,200,0,'rpm','Continuous drill-steel rotation · ± direction']
].map(([id,label,min,max,home,unit,hint])=>({id,label,min,max,home,unit,hint,
  rangeNote:id.endsWith('Rotary')?'demo speed · not a position limit':id==='upperCrowd'?'source max · zero stack preview':'axesInit command range'}));
export const referenceState = () => Object.fromEntries(joints.map(j=>[j.id,j.home]));
// 530v2 StatePositions + machineInit, non-GPS Track nominal pose.
// Upper crowd Track command is disabled in source: use its declared nominal
// position for this deterministic viewer reset. Pitch compensates the model's
// composed lift angles, rather than using the source 8-degree travel lean.
export const trackDefaultState = () => ({...referenceState(),boomLift:25,
  jointLift:28,xSlide:.15,zSlide:1.0486,mastSlide:1.85,
  lowerCrowd:1.60,upperCrowd:2.45,pitch:0,roll:0});
export const screwDiameter = .1016; // owner: 4 inches, metres
