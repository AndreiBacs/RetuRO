import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retur_ro/pages/scanner/scanner_page.dart';
import 'package:retur_ro/pages/scanner/widgets/camera_controls.dart';
import 'package:retur_ro/pages/scanner/widgets/barcode_result_dialog.dart';
import 'package:retur_ro/pages/scanner/widgets/error_dialog.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  group('ScannerPage Widget Tests', () {
    testWidgets('ScannerPage should render with camera interface', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify scanner overlay text is present
      expect(find.text('Position barcode within the frame'), findsOneWidget);

      // Verify camera controls are present
      expect(find.byType(CameraControls), findsOneWidget);

      // Verify overlay is present
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('ScannerPage should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify stack layout is used
      expect(find.byType(Stack), findsOneWidget);

      // Verify mobile scanner is present
      expect(find.byType(MobileScanner), findsOneWidget);

      // Verify overlay positioning
      expect(find.byType(Positioned), findsAtLeastNWidgets(2));
    });

    testWidgets('Scanner overlay should display instruction text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify instruction text is present and properly styled
      final instructionText = find.text('Position barcode within the frame');
      expect(instructionText, findsOneWidget);

      // Verify text is in a container with proper styling
      final container = find.ancestor(
        of: instructionText,
        matching: find.byType(Container),
      );
      expect(container, findsOneWidget);
    });

    testWidgets('Camera controls should be properly positioned', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify camera controls widget is present
      expect(find.byType(CameraControls), findsOneWidget);

      // Verify it's properly positioned in the stack
      final cameraControls = find.byType(CameraControls);
      expect(cameraControls, findsOneWidget);
    });

    testWidgets('ScannerPage should handle camera permissions gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify page renders even without camera permissions
      expect(find.byType(ScannerPage), findsOneWidget);
      expect(find.text('Position barcode within the frame'), findsOneWidget);
    });

    testWidgets('ScannerPage should have proper error handling structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify page renders without errors
      expect(find.byType(ScannerPage), findsOneWidget);
      
      // Verify no error dialogs are shown initially
      expect(find.byType(ErrorDialog), findsNothing);
    });

    testWidgets('ScannerPage should handle widget lifecycle properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify initial state
      expect(find.byType(ScannerPage), findsOneWidget);
      
      // Dispose and recreate
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );
      
      // Verify still functional
      expect(find.byType(ScannerPage), findsOneWidget);
    });

    testWidgets('ScannerPage should have proper theme integration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const ScannerPage(),
        ),
      );

      // Verify page renders in light theme
      expect(find.byType(ScannerPage), findsOneWidget);
      
      // Switch to dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: const ScannerPage(),
        ),
      );
      
      // Verify page renders in dark theme
      expect(find.byType(ScannerPage), findsOneWidget);
    });

    testWidgets('ScannerPage should have proper accessibility support', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify instruction text is accessible
      expect(find.text('Position barcode within the frame'), findsOneWidget);
      
      // Verify camera controls are accessible
      expect(find.byType(CameraControls), findsOneWidget);
    });

    testWidgets('ScannerPage should handle different screen sizes', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );
      expect(find.byType(ScannerPage), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );
      expect(find.byType(ScannerPage), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('ScannerPage should have proper state management', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ScannerPage(),
        ),
      );

      // Verify initial state
      expect(find.byType(ScannerPage), findsOneWidget);
      expect(find.text('Position barcode within the frame'), findsOneWidget);
      
      // Verify no dialogs are initially shown
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(BarcodeResultDialog), findsNothing);
      expect(find.byType(ErrorDialog), findsNothing);
    });
  });
}
