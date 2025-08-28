import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/features/test/test_screen.dart';

void main() {
  group('Drag and Drop Test Mode', () {
    testWidgets('should display draggable chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TestScreen(topicId: 'test-topic'),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify that draggable chips are present
      expect(find.text('DER'), findsOneWidget);
      expect(find.text('DIE'), findsOneWidget);
      expect(find.text('DAS'), findsOneWidget);
    });

    testWidgets('should have drop zone', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TestScreen(topicId: 'test-topic'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify drop zone is present
      expect(find.text('Drop article here'), findsOneWidget);
    });

    testWidgets('should handle tap on chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TestScreen(topicId: 'test-topic'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on a chip
      await tester.tap(find.text('DER'));
      await tester.pumpAndSettle();

      // Verify that the chip was selected (this would depend on the actual card data)
      // Since we don't have real data in tests, we just verify the interaction doesn't crash
    });
  });
}
