import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battletech_calc/app/app_shell.dart';

// Entry point of the application.
// ProviderScope is required by Riverpod — it must wrap the entire app so that
// all providers are accessible anywhere in the widget tree.
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// MyApp is the root widget of the application.
// It is stateless because the app-level configuration (theme, routing) never changes at runtime.
// All dynamic state lives in Riverpod providers, not here.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Title shown in the device's app switcher.
      title: 'BattleTech Calc',

      // App-wide theme. ColorScheme.fromSeed generates a full Material 3
      // color palette derived from a single seed color.
      // Change seedColor here to retheme the entire app at once.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),

      // AppShell is the root layout — it owns the bottom navigation bar
      // and controls which feature screen is displayed.
      home: const AppShell(),
    );
  }
}
