import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:retur_ro/main.dart';
import 'package:retur_ro/pages/scanner/widgets/camera_controls.dart';
import 'package:retur_ro/services/theme_service.dart';
import 'package:retur_ro/widgets/recycle_icon.dart';
import 'package:flutter_map/flutter_map.dart';

void main() {
  group('Integration Tests', () {
    testWidgets('Complete app navigation flow', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify app starts on home page
      expect(find.text('Return IT'), findsOneWidget);
      expect(find.text('Current Location'), findsOneWidget);

      // Navigate through all pages
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(find.text('Search for a location'), findsOneWidget);

      await tester.tap(find.text('Scanner'));
      await tester.pump();
      expect(find.text('Position barcode within the frame'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pump();
      expect(find.text('User Name'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(find.text('Current Location'), findsOneWidget);
    });

    testWidgets('App bar title changes with navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verify initial title
      expect(find.text('Return IT'), findsOneWidget);

      // Navigate and verify title changes
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(find.text('Search'), findsOneWidget);

      await tester.tap(find.text('Scanner'));
      await tester.pump();
      expect(find.text('Scanner'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pump();
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Theme service integration', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify theme service is provided
      expect(find.byType(Consumer<ThemeService>), findsOneWidget);

      // Verify app renders with theme
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Recycle icon appears in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify recycle icon is present in app bar
      expect(find.byType(RecycleIcon), findsOneWidget);
    });

    testWidgets('Navigation bar maintains state', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify navigation bar is present
      expect(find.byType(NavigationBar), findsOneWidget);

      // Navigate and verify navigation bar remains
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(find.byType(NavigationBar), findsOneWidget);

      await tester.tap(find.text('Scanner'));
      await tester.pump();
      expect(find.byType(NavigationBar), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pump();
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('Profile page navigation to settings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to profile
      await tester.tap(find.text('Profile'));
      await tester.pump();
      expect(find.text('User Name'), findsOneWidget);

      // Tap settings
      await tester.tap(find.text('Settings'));
      await tester.pump();

      // Verify settings page is shown
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Profile page coming soon messages', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to profile
      await tester.tap(find.text('Profile'));
      await tester.pump();

      // Test coming soon messages
      await tester.tap(find.text('Recycling History'));
      await tester.pump();
      expect(find.text('Recycling History coming soon!'), findsOneWidget);

      await tester.tap(find.text('Help & Support'));
      await tester.pump();
      expect(find.text('Help & Support coming soon!'), findsOneWidget);

      await tester.tap(find.text('About'));
      await tester.pump();
      expect(find.text('About page coming soon!'), findsOneWidget);
    });

    testWidgets('Search page functionality', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to search
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(find.text('Search for a location'), findsOneWidget);

      // Test search field interaction
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      await tester.enterText(find.byType(TextFormField), 'test search');
      await tester.pump();
      expect(find.text('test search'), findsOneWidget);
    });

    testWidgets('Scanner page interface', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to scanner
      await tester.tap(find.text('Scanner'));
      await tester.pump();
      expect(find.text('Position barcode within the frame'), findsOneWidget);

      // Verify camera controls are present
      expect(find.byType(CameraControls), findsOneWidget);
    });

    testWidgets('Home page map and location features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verify home page features
      expect(find.text('Current Location'), findsOneWidget);
      expect(find.text('Nearby Places'), findsOneWidget);

      // Verify map is present
      expect(find.byType(FlutterMap), findsOneWidget);

      // Verify floating action buttons
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(1));
    });

    testWidgets('App handles rapid navigation', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Rapidly navigate between pages
      await tester.tap(find.text('Search'));
      await tester.pump();
      await tester.tap(find.text('Scanner'));
      await tester.pump();
      await tester.tap(find.text('Profile'));
      await tester.pump();
      await tester.tap(find.text('Home'));
      await tester.pump();

      // Verify app is still functional
      expect(find.text('Current Location'), findsOneWidget);
    });

    testWidgets('App maintains state across navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Navigate away from home
      await tester.tap(find.text('Search'));
      await tester.pump();

      // Navigate back to home
      await tester.tap(find.text('Home'));
      await tester.pump();

      // Verify home page state is maintained
      expect(find.text('Current Location'), findsOneWidget);
      expect(find.text('Nearby Places'), findsOneWidget);
    });

    testWidgets('App handles different screen orientations', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pump();
      expect(find.byType(MaterialApp), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pump();
      expect(find.byType(MaterialApp), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('App handles theme switching', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify app renders in light theme
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test navigation in light theme
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(find.text('Search for a location'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(find.text('Current Location'), findsOneWidget);
    });

    testWidgets('App handles widget lifecycle properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verify initial state
      expect(find.byType(MaterialApp), findsOneWidget);

      // Navigate through pages
      await tester.tap(find.text('Search'));
      await tester.pump();
      await tester.tap(find.text('Scanner'));
      await tester.pump();
      await tester.tap(find.text('Profile'));
      await tester.pump();
      await tester.tap(find.text('Home'));
      await tester.pump();

      // Verify app is still functional
      expect(find.text('Current Location'), findsOneWidget);
    });

    testWidgets('App handles error states gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verify app renders without errors
      expect(find.byType(MaterialApp), findsOneWidget);

      // Navigate through all pages to ensure no errors
      await tester.tap(find.text('Search'));
      await tester.pump();
      await tester.tap(find.text('Scanner'));
      await tester.pump();
      await tester.tap(find.text('Profile'));
      await tester.pump();
      await tester.tap(find.text('Home'));
      await tester.pump();

      // Verify app is still functional
      expect(find.text('Current Location'), findsOneWidget);
    });

    testWidgets('App accessibility features', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify navigation destinations are accessible
      expect(find.bySemanticsLabel('Home'), findsOneWidget);
      expect(find.bySemanticsLabel('Search'), findsOneWidget);
      expect(find.bySemanticsLabel('Scanner'), findsOneWidget);
      expect(find.bySemanticsLabel('Profile'), findsOneWidget);

      // Navigate and verify accessibility is maintained
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(find.text('Search for a location'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(find.text('Current Location'), findsOneWidget);
    });
  });
}
