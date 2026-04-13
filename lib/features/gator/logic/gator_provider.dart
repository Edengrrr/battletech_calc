import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battletech_calc/features/gator/data/gator_input.dart';
import 'package:battletech_calc/features/gator/logic/gator_calculator.dart';

// Holds the current state of all GATOR inputs.
// Notifier lets the UI update individual fields without replacing the whole object.
class GatorNotifier extends Notifier<GatorInput> {
  @override
  GatorInput build() => const GatorInput();

  void updateGunnerySkill(int value) =>
      state = state.copyWith(gunnerySkill: value);

  void updateAttackerMovement(AttackerMovement value) =>
      state = state.copyWith(attackerMovement: value);

  void updateTargetHexesMoved(int value) =>
      state = state.copyWith(targetHexesMoved: value);

  void updateTargetMovementAdditional(TargetMovementAdditional value) =>
      state = state.copyWith(targetMovementAdditional: value);

  void updateRangeBracket(RangeBracket value) =>
      state = state.copyWith(rangeBracket: value);

  void updateMinimumRange(MinimumRange value) =>
      state = state.copyWith(minimumRange: value);

  void updateWoodsSmoke(WoodsSmoke value) =>
      state = state.copyWith(woodsSmoke: value);

  void updateTargetPartialCover(bool value) =>
      state = state.copyWith(targetPartialCover: value);

  void updateTargetProne(TargetProne value) =>
      state = state.copyWith(targetProne: value);

  void updateAttackerProne(bool value) =>
      state = state.copyWith(attackerProne: value);

  void updateSecondaryTarget(SecondaryTarget value) =>
      state = state.copyWith(secondaryTarget: value);

  void updateArmCritical(ArmCritical value) =>
      state = state.copyWith(armCritical: value);

  void updateHeatModifier(HeatModifier value) =>
      state = state.copyWith(heatModifier: value);

  void updateOtherModifier(int value) =>
      state = state.copyWith(otherModifier: value);

  void reset() => state = const GatorInput();
}

// The provider the UI will watch to get current inputs and to-hit result.
final gatorProvider = NotifierProvider<GatorNotifier, GatorInput>(
  GatorNotifier.new,
);

// Derived provider that computes the to-hit number from current inputs.
final toHitProvider = Provider<int>((ref) {
  final input = ref.watch(gatorProvider);
  return calculateToHit(input);
});
