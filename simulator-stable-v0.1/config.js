// Model configuration v0.1. Dimensions in metres; UI rotations in degrees.
// Command ranges: PLC 530v2 axesInit; lower crowd also uses machineInit.
// Geometry and encoder-to-drawing zero offsets remain visual estimates.
export const geometry = Object.freeze({
  revision: 'TD3 visual model 0.2 photo proportions', arm: 1.35, reach: 1.35,
  boomRise: .50, trunnionDrop: .15, pivotHeight: .55,
  backboneHeight: 2.1, rollHeight: .25, mastLength: 6.2,
  mastBottom: -1.8, lowerHome: -.65, upperSeparation: 1.6,
  // machineInit: pitch-to-drill perpendicular distance = 36.8 in (cm conversion).
  pitchToRod: .93472, centralizerWidth: .62, centralizerThickness: .16,
  mastOffset: .25, toolOffset: -.25,
  mastCOR: 1.95, lowerCrowdCOR: 1.60 // source constant and persistent declaration default
});
export const joints = [
  ['boomSwing','Boom swing',-27,27,0,'°','Positive feedback → arm swings right'],
  ['boomLift','Boom lift',-18,30,0,'°','Increasing → boom pivots upward'],
  ['jointLift','Joint lift',-12,30,0,'°','Increasing → trunnion tilts rearward'],
  ['yaw','Yaw',-29,29,0,'°','Positive feedback → arm swings left'],
  ['xSlide','X-slide',0,.30,0,'m','Increasing → longer rearward reach'],
  ['pitch','Pitch',-6,80,0,'°','Direction corrected by owner · drawing zero estimated'],
  ['zSlide','Z-slide',.02,1.675,.02,'m','White slide carries downstream assembly'],
  ['roll','Rotator / roll',-38,38,0,'°','Mast rolls; backbone stays fixed'],
  ['mastSlide','Mast slide',0,1.975,1.95,'m','COR reference 195 cm · whole mast and crowds translate'],
  ['lowerCrowd','Lower crowd',.37,2.70,1.60,'m','COR reference 160 cm · source default, adjustable on rig'],
  ['upperCrowd','Upper crowd · relative',.01,3,.01,'m','Travel relative to lower crowd'],
  ['lowerRotary','Lower rotary speed',-60,60,0,'rpm','Continuous ground-screw rotation · ± direction'],
  ['upperRotary','Upper rotary speed',-200,200,0,'rpm','Continuous drill-steel rotation · ± direction']
].map(([id,label,min,max,home,unit,hint])=>({id,label,min,max,home,unit,hint,
  rangeNote:id.endsWith('Rotary')?'demo speed · not a position limit':'axesInit command range'}));
export const referenceState = () => Object.fromEntries(joints.map(j=>[j.id,j.home]));
// 530v2 StatePositions + machineInit, non-GPS Track nominal pose.
// Upper crowd Track command is disabled in source: use its declared nominal
// position for this deterministic viewer reset. Pitch compensates the model's
// composed lift angles, rather than using the source 8-degree travel lean.
export const trackDefaultState = () => ({...referenceState(),boomLift:25,
  jointLift:28,xSlide:.15,zSlide:1.0486,mastSlide:1.85,
  lowerCrowd:1.60,upperCrowd:2.45,pitch:3,roll:0});
export const screwDiameter = .1016; // owner: 4 inches, metres
