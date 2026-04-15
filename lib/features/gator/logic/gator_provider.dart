import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battletech_calc/features/gator/data/gator_input.dart';
import 'package:battletech_calc/features/gator/logic/gator_calculator.dart';

// ---------------------------------------------------------------------------
// GATOR PROVIDER
// ---------------------------------------------------------------------------
// This file wires the GATOR data model into Riverpod so the UI can read
// current values and trigger updates reactively.
//
// Two providers are defined:
//   gatorProvider  — holds the full GatorInput state, updated by user actions
//   toHitProvider  — derives the final to-hit number from gatorProvider
//
// The UI watches toHitProvider to display the result, and calls methods on
// gatorProvider.notifier to update individual input fields.
// ---------------------------------------------------------------------------

// GatorNotifier manages the mutable state of a GatorInput.
// It extends Notifier<GatorInput> which is Riverpod's class for managing
// a piece of state with methods that can change it.
// Each update method uses copyWith() to produce a new immutable GatorInput
// with only the changed field updated — the rest stay the same.
class GatorNotifier extends Notifier<GatorInput> {
  // build() returns the initial state when the provider is first accessed.
  // GatorInput() with no arguments uses all default values (gunnery 4, etc.).
  @override
  GatorInput build() => const GatorInput();

  // --- Update methods ---
  // Each method updates exactly one field and leaves all others unchanged.
  // The UI calls these when the player makes a selection.

  // G — update the attacker's gunnery skill (1–6).
  void updateGunnerySkill(int value) =>
      state = state.copyWith(gunnerySkill: value);

  // G — update the attacker's piloting skill (1–6), used for melee attacks.
  void updatePilotingSkill(int value) =>
      state = state.copyWith(pilotingSkill: value);

  // A — update the attacker's movement type for this turn.
  void updateAttackerMovement(AttackerMovement value) =>
      state = state.copyWith(attackerMovement: value);

  // T — update the number of hexes the target moved this turn.
  void updateTargetHexesMoved(int value) =>
      state = state.copyWith(targetHexesMoved: value);

  // T — update whether the target jumped or sprinted (additional modifier).
  void updateTargetMovementAdditional(TargetMovementAdditional value) =>
      state = state.copyWith(targetMovementAdditional: value);

  // R — update the range bracket (short/medium/long).
  void updateRangeBracket(RangeBracket value) =>
      state = state.copyWith(rangeBracket: value);

  // R — update the minimum range penalty selection.
  void updateMinimumRange(MinimumRange value) =>
      state = state.copyWith(minimumRange: value);

  // O — update the woods/smoke terrain modifier.
  void updateWoodsSmoke(WoodsSmoke value) =>
      state = state.copyWith(woodsSmoke: value);

  // O — toggle whether the target is in partial cover.
  void updateTargetPartialCover(bool value) =>
      state = state.copyWith(targetPartialCover: value);

  // O — update the target prone status and attacker adjacency.
  void updateTargetProne(TargetProne value) =>
      state = state.copyWith(targetProne: value);

  // O — toggle whether the attacking mech is prone.
  void updateAttackerProne(bool value) =>
      state = state.copyWith(attackerProne: value);

  // O — update the secondary target arc modifier.
  void updateSecondaryTarget(SecondaryTarget value) =>
      state = state.copyWith(secondaryTarget: value);

  // O — update the arm critical damage modifier.
  void updateArmCritical(ArmCritical value) =>
      state = state.copyWith(armCritical: value);

  // O — update the heat threshold modifier.
  void updateHeatModifier(HeatModifier value) =>
      state = state.copyWith(heatModifier: value);

  // O — update the free-entry other modifier (positive or negative int).
  void updateOtherModifier(int value) =>
      state = state.copyWith(otherModifier: value);

  // Resets all inputs back to their default values.
  // Called by the Reset button in the UI.
  void reset() => state = const GatorInput();
}

// The main provider for GATOR state.
// The UI reads current input values from this and calls methods on its notifier
// to update them. Use ref.watch(gatorProvider) to rebuild when state changes,
// or ref.read(gatorProvider.notifier) to just call a method without rebuilding.
final gatorProvider = NotifierProvider<GatorNotifier, GatorInput>(
  GatorNotifier.new,
);

// Derived provider that always reflects the current to-hit number.
// It watches gatorProvider and automatically recomputes whenever any input changes.
// The UI watches this to display the result — it never calls calculateToHit() directly.
final toHitProvider = Provider<int>((ref) {
  final input = ref.watch(gatorProvider);
  return calculateToHit(input);
});

// Derived provider that computes the melee to-hit number from current inputs.
// Uses piloting skill as the base instead of gunnery skill.
final meleeToHitProvider = Provider<int>((ref) {
  final input = ref.watch(gatorProvider);
  return calculateMeleeToHit(input);
});
