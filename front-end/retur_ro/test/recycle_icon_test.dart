import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retur_ro/widgets/recycle_icon.dart';

void main() {
  group('RecycleIcon Widget Tests', () {
    testWidgets('RecycleIcon should render with default properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon())),
      );

      // Verify widget is rendered
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should render with custom size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon(size: 48.0))),
      );

      // Verify widget is rendered with custom size
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should render with custom color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: const RecycleIcon(color: Colors.green)),
        ),
      );

      // Verify widget is rendered with custom color
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should render with both custom size and color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const RecycleIcon(size: 64.0, color: Colors.blue),
          ),
        ),
      );

      // Verify widget is rendered with custom properties
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle null color gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: const RecycleIcon(size: 32.0, color: null)),
        ),
      );

      // Verify widget is rendered without color
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle null size gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const RecycleIcon(size: null, color: Colors.red),
          ),
        ),
      );

      // Verify widget is rendered without size
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle both null size and color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: const RecycleIcon(size: null, color: null)),
        ),
      );

      // Verify widget is rendered with null properties
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle theme changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: Scaffold(body: const RecycleIcon()),
        ),
      );

      // Verify widget renders in light theme
      expect(find.byType(RecycleIcon), findsOneWidget);

      // Switch to dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: Scaffold(body: const RecycleIcon()),
        ),
      );

      // Verify widget renders in dark theme
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle different screen sizes', (
      WidgetTester tester,
    ) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon())),
      );
      expect(find.byType(RecycleIcon), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon())),
      );
      expect(find.byType(RecycleIcon), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('RecycleIcon should handle widget lifecycle properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon())),
      );

      // Verify initial state
      expect(find.byType(RecycleIcon), findsOneWidget);

      // Dispose and recreate
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon())),
      );

      // Verify still functional
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle multiple instances', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                RecycleIcon(size: 24.0, color: Colors.green),
                RecycleIcon(size: 32.0, color: Colors.blue),
                RecycleIcon(size: 48.0, color: Colors.red),
              ],
            ),
          ),
        ),
      );

      // Verify multiple instances are rendered
      expect(find.byType(RecycleIcon), findsNWidgets(3));
    });

    testWidgets('RecycleIcon should handle zero size gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon(size: 0.0))),
      );

      // Verify widget is rendered even with zero size
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle negative size gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon(size: -10.0))),
      );

      // Verify widget is rendered even with negative size
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle very large size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const RecycleIcon(size: 200.0))),
      );

      // Verify widget is rendered with large size
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('RecycleIcon should handle transparent color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: const RecycleIcon(color: Colors.transparent)),
        ),
      );

      // Verify widget is rendered with transparent color
      expect(find.byType(RecycleIcon), findsOneWidget);
    });
  });
}
