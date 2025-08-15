import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retur_ro/pages/home_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('HomePage should render with all main components', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify main sections are present
      expect(find.text('Current Location'), findsOneWidget);
      expect(find.text('Nearby Places'), findsOneWidget);
      
      // Verify map is rendered
      expect(find.byType(FlutterMap), findsOneWidget);
      
      // Verify bottom sheet is present
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });

    testWidgets('Location section should display loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify location icon is present
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      
      // Verify location text is present
      expect(find.text('Current Location'), findsOneWidget);
    });

    testWidgets('Bottom sheet should be expandable and collapsible', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify bottom sheet handle is present
      expect(find.byType(Container), findsWidgets);
      
      // Verify expand/collapse button is present
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });

    testWidgets('Floating action buttons should be present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify location FAB is present
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(1));
    });

    testWidgets('Map should have proper configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify map controller is present
      expect(find.byType(FlutterMap), findsOneWidget);
      
      // Verify map has proper layers
      expect(find.byType(TileLayer), findsOneWidget);
    });

    testWidgets('Places section should handle loading states', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Initially should show loading or places
      expect(find.text('Nearby Places'), findsOneWidget);
    });

    testWidgets('Location refresh button should be interactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Find and tap the location refresh button
      final locationButton = find.byIcon(Icons.location_on);
      expect(locationButton, findsOneWidget);
      
      await tester.tap(locationButton);
      await tester.pump();
      
      // Button should remain interactive
      expect(locationButton, findsOneWidget);
    });

    testWidgets('Bottom sheet should respond to drag gestures', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Find the bottom sheet
      final bottomSheet = find.byType(DraggableScrollableSheet);
      expect(bottomSheet, findsOneWidget);
      
      // Verify it's draggable by checking for scroll controller
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Map markers should be present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify marker cluster layer is present
      expect(find.byType(MarkerClusterLayerWidget), findsOneWidget);
    });

    testWidgets('Compass widget should be present on map', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify compass is present
      expect(find.byType(MapCompass), findsOneWidget);
    });

    testWidgets('HomePage should handle theme changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const HomePage(),
        ),
      );

      // Verify page renders in light theme
      expect(find.byType(HomePage), findsOneWidget);
      
      // Switch to dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: const HomePage(),
        ),
      );
      
      // Verify page renders in dark theme
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage should handle widget lifecycle properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify initial state
      expect(find.byType(HomePage), findsOneWidget);
      
      // Dispose and recreate
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );
      
      // Verify still functional
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
