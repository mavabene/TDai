import {geometry as g} from './config.js';
// Distances along the mast, in metres. This reproduces 530v2's
// updateCalculatedDimensions, independent of world pitch/roll or mast lift.
export function crowdTopClearance(state){
 return g.mastTop-(g.centralizerTop+state.lowerCrowd+
  state.upperCrowd+3*g.sledLength+g.drifterGap);
}
export const crowdTopMargin=.05; // DRIFTER_TO_TOP_MIN, machineInit
// Source UPPER_CROWD manual non-operator branch: current UC + clearance - 5 cm.
// Keep the other coordinate fixed when limiting a user's pose command.
export function crowdCommandMaximum(id,state){
 const total=g.mastTop-g.centralizerTop-3*g.sledLength-g.drifterGap-crowdTopMargin;
 // Remove binary subtraction tails at exact shared limits (e.g. LC=160 cm).
 // Nanometre rounding is far below the precision of any supplied dimension.
 if(id==='upperCrowd')return Number((total-state.lowerCrowd).toFixed(9));
 if(id==='lowerCrowd')return Math.min(2.70,Number((total-state.upperCrowd).toFixed(9)));
 throw Error(`Not a crowd axis: ${id}`);
}
export const drillTipLocalY=-(g.upperSeparation-g.chuckBottom+g.drillBelowChuckAtUpperZero);
