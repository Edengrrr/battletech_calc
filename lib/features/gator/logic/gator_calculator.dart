import 'package:battletech_calc/features/gator/data/gator_input.dart';

// Converts raw hex movement count into the Target Movement Modifier (TMM).
// This follows the official BattleTech hex bracket table:
//   0-2 hexes  = +0
//   3-4 hexes  = +1
//   5-6 hexes  = +2
//   7-9 hexes  = +3
//   10-17 hexes = +4
//   18-25 hexes = +5
// The result is combined with targetMovementAdditional (jumped/sprinted bonus)
// in calculateToHit() to get the full T modifier.
int targetMovementModifier(int hexesMoved) {
  if (hexesMoved <= 2) return 0;
  if (hexesMoved <= 4) return 1;
  if (hexesMoved <= 6) return 2;
  if (hexesMoved <= 9) return 3;
  if (hexesMoved <= 17) return 4;
  return 5; // 18-25 hexes
}

// Calculates the final GATOR to-hit number by summing all modifiers.
// Each letter of GATOR contributes one or more values:
//   G = gunnerySkill (base to-hit, typically 4 for a standard MechWarrior)
//   A = attackerMovement.modifier (stationary=0, walk=1, run=2, jump=3)
//   T = targetMovementModifier (hex table) + targetMovementAdditional (jumped/sprinted)
//   O = woodsSmoke + targetPartialCover + targetProne + attackerProne
//       + secondaryTarget + armCritical + heatModifier + otherModifier (free entry)
//   R = rangeBracket (short=0, medium=+2, long=+4) + minimumRange penalty
//
// The result can legally exceed 12 — display it as-is per game rules.
int calculateToHit(GatorInput input) {
  return input.gunnerySkill +                              // G
      input.attackerMovement.modifier +                    // A
      targetMovementModifier(input.targetHexesMoved) +     // T (hex table)
      input.targetMovementAdditional.modifier +            // T (jumped/sprinted)
      input.rangeBracket.modifier +                        // R (bracket)
      input.minimumRange.modifier +                        // R (minimum range penalty)
      input.woodsSmoke.modifier +                          // O
      (input.targetPartialCover ? 1 : 0) +                 // O
      input.targetProne.modifier +                         // O
      (input.attackerProne ? 2 : 0) +                      // O
      input.secondaryTarget.modifier +                     // O
      input.armCritical.modifier +                         // O
      input.heatModifier.modifier +                        // O
      input.otherModifier;                                 // O (free entry)
}
