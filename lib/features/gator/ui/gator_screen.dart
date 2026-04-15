import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battletech_calc/features/gator/logic/gator_provider.dart';
import 'package:battletech_calc/features/gator/ui/gator_header.dart';
import 'package:battletech_calc/features/gator/ui/panels/g_panel.dart';

// GatorScreen is the main screen for the GATOR to-hit calculator.
// It uses ConsumerStatefulWidget instead of ConsumerWidget because it needs
// both local UI state (_selected section) AND access to Riverpod providers.
// - ConsumerWidget: Riverpod access only, no local state
// - ConsumerStatefulWidget: both local state AND Riverpod access
class GatorScreen extends ConsumerStatefulWidget {
  const GatorScreen({super.key});

  @override
  ConsumerState<GatorScreen> createState() => _GatorScreenState();
}

class _GatorScreenState extends ConsumerState<GatorScreen> {
  // Tracks which GATOR letter the user has tapped.
  // This controls which input panel is shown in the body below the header.
  // Defaults to G so the app opens ready for gunnery skill input.
  GatorSection _selected = GatorSection.g;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GATOR')),
      body: Column(
        children: [
          // GatorHeader displays the G-A-T-O-R letter circles, their current
          // modifier values, and the total to-hit number.
          // It notifies us when a letter is tapped so we can swap the input panel.
          Padding(
            padding: const EdgeInsets.all(12),
            child: GatorHeader(
              selected: _selected,
              onSectionTap: (section) {
                // setState triggers a rebuild so the input panel below updates.
                setState(() => _selected = section);
              },
            ),
          ),

          // Visual separator between the header and the input panel.
          const Divider(height: 1),

          // Shows the input panel for the currently selected GATOR section.
          Expanded(child: _buildPanel(_selected)),

          // Reset button clears all inputs back to their defaults.
          // ref.read is used here instead of ref.watch because we only need
          // to call a method on the notifier — we don't need to rebuild when
          // the provider value changes.
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.tonal(
              onPressed: () => ref.read(gatorProvider.notifier).reset(),
              child: const Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the appropriate input panel widget for the selected GATOR section.
  Widget _buildPanel(GatorSection section) {
    switch (section) {
      case GatorSection.g:
        return const GPanel();
      case GatorSection.a:
      case GatorSection.t:
      case GatorSection.o:
      case GatorSection.r:
        return const Center(child: Text('Coming soon'));
    }
  }
}
