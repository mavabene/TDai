// Model configuration v0.1. Dimensions in metres; UI rotations in degrees.
// Only arm lengths / X travel are source nominal. All other numbers are visual
// estimates, including pivot offsets, reference elevations and display ranges.
export const geometry = Object.freeze({
  revision: 'TD3 visual model 0.1', arm: 1.35, reach: 1.35,
  boomRise: .65, trunnionDrop: .65, pivotHeight: 1.05,
  backboneHeight: 2.1, rollHeight: 1.35, mastLength: 6.2,
  mastBottom: -2.8, lowerHome: -2.6, upperSeparation: 1.6,
  mastOffset: -.32, toolOffset: -.25
});
export const joints = [
  ['boomSwing','Boom swing',-35,35,0,'°','Positive feedback → arm swings right'],
  ['boomLift','Boom lift',-12,35,0,'°','Increasing → boom pivots upward'],
  ['jointLift','Joint lift',-20,25,0,'°','Increasing → trunnion tilts rearward'],
  ['yaw','Yaw',-45,45,0,'°','Positive feedback → arm swings left'],
  ['xSlide','X-slide',0,.30,0,'m','Increasing → longer rearward reach'],
  ['pitch','Pitch',-20,20,0,'°','Display sign / zero estimated'],
  ['zSlide','Z-slide',0,1.2,0,'m','White slide carries downstream assembly'],
  ['roll','Rotator / roll',-25,25,0,'°','Mast rolls; backbone stays fixed'],
  ['mastSlide','Mast slide',-.5,1.0,0,'m','Whole mast and both crowds translate'],
  ['lowerCrowd','Lower crowd',-.25,2.0,0,'m','Carries lower rotary and upper crowd'],
  ['upperCrowd','Upper crowd · relative',-.7,1.4,0,'m','Travel relative to lower crowd'],
  ['lowerRotary','Lower rotary',-180,180,0,'°','Ground screw rotation'],
  ['upperRotary','Upper rotary',-180,180,0,'°','Drill steel rotation']
].map(([id,label,min,max,home,unit,hint])=>({id,label,min,max,home,unit,hint}));
export const referenceState = () => Object.fromEntries(joints.map(j=>[j.id,j.home]));
