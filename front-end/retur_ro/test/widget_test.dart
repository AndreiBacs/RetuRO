// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retur_ro/main.dart';

void main() {
  testWidgets('Navigation app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('Return IT'), findsOneWidget);

    // Verify that the navigation bar is present
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify that all navigation destinations are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify that the home page content is displayed initially
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.text('Welcome to the home page!'), findsOneWidget);

    // Test navigation to Search page
    await tester.tap(find.text('Search'));
    await tester.pump();

    // Test navigation to Profile page
    await tester.tap(find.text('Profile'));
    await tester.pump();

    // Navigate back to Home
    await tester.tap(find.text('Home'));
    await tester.pump();

    // Verify we're back on the home page
    expect(find.text('Home Page'), findsOneWidget);
  });
}
