import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cactusdemo/main.dart';

void main() {
  testWidgets('TTS Demo app starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final container = ProviderContainer();
    
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CactusTTSApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('Cactus TTS Demo'), findsOneWidget);
    
    // Verify that the settings icon is present
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}