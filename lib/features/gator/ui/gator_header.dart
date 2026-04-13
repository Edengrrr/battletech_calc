import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battletech_calc/features/gator/logic/gator_provider.dart';

// Which GATOR letter is currently selected for the input panel.
enum GatorSection { g, a, t, o, r }

class GatorHeader extends ConsumerWidget {
  final GatorSection selected;
  final ValueChanged<GatorSection> onSectionTap;

  const GatorHeader({
    super.key,
    required this.selected,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(gatorProvider);
    final toHit = ref.watch(toHitProvider);

    // Modifier value shown under each letter
    final values = [
      input.gunnerySkill,
      input.attackerMovement.modifier,
      // target movement is a combination of hex modifier + additional
      0, // placeholder for T — we'll calculate this shortly
      0, // placeholder for O — sum of all O modifiers
      input.rangeBracket.modifier + input.minimumRange.modifier,
    ];

    return Row(
      children: [
        ...GatorSection.values.map((section) {
          final index = section.index;
          final isSelected = selected == section;
          final label = section.name.toUpperCase();

          return Expanded(
            child: GestureDetector(
              onTap: () => onSectionTap(section),
              child: Column(
                children: [
                  _Circle(label: label, highlighted: isSelected),
                  const SizedBox(height: 4),
                  _Circle(
                    label: '${values[index]}',
                    highlighted: false,
                    small: true,
                  ),
                ],
              ),
            ),
          );
        }),
        // Final value
        Column(
          children: [
            const Text('Total', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            _Circle(label: '$toHit', highlighted: true, small: true),
          ],
        ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  final String label;
  final bool highlighted;
  final bool small;

  const _Circle({
    required this.label,
    required this.highlighted,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 40.0 : 56.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: highlighted
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: small ? 14 : 22,
            fontWeight: FontWeight.bold,
            color: highlighted
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
