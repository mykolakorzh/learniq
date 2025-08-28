import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/features/test/drag_drop_demo.dart';

void main() {
  group('Drag Drop Demo', () {
    testWidgets('should display draggable chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const DragDropDemo(),
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
        MaterialApp(
          home: const DragDropDemo(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify drop zone is present
      expect(find.text('Drop article here'), findsOneWidget);
    });

    testWidgets('should handle tap on chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const DragDropDemo(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on a chip
      await tester.tap(find.text('DER'));
      await tester.pumpAndSettle();

      // Verify that the chip was selected
      expect(find.text('DER'), findsNWidgets(2)); // One in chip, one in drop zone
    });

    testWidgets('should show correct answer animation for der', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const DragDropDemo(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on correct answer (der)
      await tester.tap(find.text('DER'));
      await tester.pumpAndSettle();

      // Wait for animation
      await tester.pump(const Duration(milliseconds: 1000));

      // Verify the image shows colored state
      expect(find.text('🎉 Colored!'), findsOneWidget);
    });

    testWidgets('should show incorrect answer animation for die', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const DragDropDemo(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on incorrect answer (die)
      await tester.tap(find.text('DIE'));
      await tester.pumpAndSettle();

      // Wait for animation
      await tester.pump(const Duration(milliseconds: 1000));

      // Verify the correct answer is shown
      expect(find.text('DER'), findsNWidgets(2)); // One in chip, one in drop zone
    });
  });
}
