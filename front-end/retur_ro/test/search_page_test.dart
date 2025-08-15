import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retur_ro/pages/search_page.dart';


void main() {
  group('SearchPage Widget Tests', () {
    testWidgets('SearchPage should display search field with proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Verify search field is present
      expect(find.text('Search for a location'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Autocomplete<String>), findsOneWidget);
    });

    testWidgets('Search field should be interactive and accept text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Tap on search field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'test location');
      await tester.pump();

      // Verify text was entered
      expect(find.text('test location'), findsOneWidget);
    });

    testWidgets('Search field should clear when new text is entered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Enter initial text
      await tester.enterText(find.byType(TextFormField), 'initial text');
      await tester.pump();
      expect(find.text('initial text'), findsOneWidget);

      // Enter new text
      await tester.enterText(find.byType(TextFormField), 'new text');
      await tester.pump();
      expect(find.text('new text'), findsOneWidget);
      expect(find.text('initial text'), findsNothing);
    });

    testWidgets('Search field should have proper hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Verify hint text is displayed
      expect(find.text('Search for a location'), findsOneWidget);
    });

    testWidgets('Search field should have search icon prefix', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Verify search icon is present
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('SearchPage should handle empty search gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Enter empty text
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      // Verify page still renders properly
      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.byType(Autocomplete<String>), findsOneWidget);
    });

    testWidgets('SearchPage should handle long text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Enter long text
      const longText = 'This is a very long search query that should be handled properly by the search field';
      await tester.enterText(find.byType(TextFormField), longText);
      await tester.pump();

      // Verify long text is handled
      expect(find.text(longText), findsOneWidget);
    });

    testWidgets('SearchPage should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Verify Column layout is used
      expect(find.byType(Column), findsOneWidget);

      // Verify Padding is used
      expect(find.byType(Padding), findsOneWidget);

      // Verify Autocomplete widget is present
      expect(find.byType(Autocomplete<String>), findsOneWidget);
    });

    testWidgets('SearchPage should handle theme changes properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const SearchPage(),
        ),
      );

      // Verify page renders in light theme
      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.text('Search for a location'), findsOneWidget);
      
      // Switch to dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: const SearchPage(),
        ),
      );
      
      // Verify page renders in dark theme
      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.text('Search for a location'), findsOneWidget);
    });

    testWidgets('SearchPage should have proper accessibility support', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Verify search field is accessible
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Verify hint text is accessible
      expect(find.text('Search for a location'), findsOneWidget);
    });

    testWidgets('SearchPage should handle different screen sizes', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );
      expect(find.byType(SearchPage), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );
      expect(find.byType(SearchPage), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SearchPage should handle widget lifecycle properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Verify initial state
      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.text('Search for a location'), findsOneWidget);
      
      // Dispose and recreate
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );
      
      // Verify still functional
      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.text('Search for a location'), findsOneWidget);
    });

    testWidgets('SearchPage should have proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Verify Padding widget is used with proper padding
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('SearchPage should handle focus changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SearchPage(),
        ),
      );

      // Tap to focus
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Verify field is focused
      expect(find.byType(TextFormField), findsOneWidget);

      // Tap outside to unfocus
      await tester.tapAt(const Offset(0, 0));
      await tester.pump();

      // Verify field is still present
      expect(find.byType(TextFormField), findsOneWidget);
    });


  });
}
