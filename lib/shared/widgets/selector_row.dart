import 'package:flutter/material.dart';

// A horizontal row of labeled buttons where only one can be selected at a time.
// Used throughout the GATOR input panels for choosing between named options.
//
// Generic type T represents the value type (usually an enum).
// When a button is tapped, onSelected is called with that button's value
// so the caller can update the provider.
class SelectorRow<T> extends StatelessWidget {
  // The list of options to display as buttons.
  final List<SelectorOption<T>> options;

  // The currently selected value — that button will appear highlighted.
  final T selected;

  // Called with the new value when the user taps a different button.
  final ValueChanged<T> onSelected;

  const SelectorRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option.value == selected;
        return ChoiceChip(
          label: Text(option.label),
          selected: isSelected,
          onSelected: (_) => onSelected(option.value),
        );
      }).toList(),
    );
  }
}

// Represents a single option in a SelectorRow.
// label is what the user sees, value is what gets passed to the provider.
class SelectorOption<T> {
  final String label;
  final T value;

  const SelectorOption({required this.label, required this.value});
}
