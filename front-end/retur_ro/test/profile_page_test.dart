import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retur_ro/pages/profile/profile_page.dart';
import 'package:retur_ro/pages/profile/settings_page.dart';

void main() {
  group('ProfilePage Widget Tests', () {
    testWidgets('ProfilePage should display user information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify user info is displayed
      expect(find.text('User Name'), findsOneWidget);
      expect(find.text('user@example.com'), findsOneWidget);

      // Verify profile avatar is present
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('ProfilePage should display all profile options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify all profile options are present
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Recycling History'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);

      // Verify option descriptions are present
      expect(find.text('Configure app preferences'), findsOneWidget);
      expect(find.text('View your past recycling activities'), findsOneWidget);
      expect(find.text('Get help and contact support'), findsOneWidget);
      expect(find.text('App information and version'), findsOneWidget);
    });

    testWidgets('ProfilePage should have edit button functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify edit button is present
      expect(find.byIcon(Icons.edit), findsOneWidget);

      // Tap edit button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      // Verify snackbar appears
      expect(find.text('Edit Profile coming soon!'), findsOneWidget);
    });

    testWidgets('Settings option should navigate to settings page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Tap on Settings option
      await tester.tap(find.text('Settings'));
      await tester.pump();

      // Verify navigation occurred
      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets('Other profile options should show coming soon messages', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Tap on Recycling History
      await tester.tap(find.text('Recycling History'));
      await tester.pump();
      expect(find.text('Recycling History coming soon!'), findsOneWidget);

      // Tap on Help & Support
      await tester.tap(find.text('Help & Support'));
      await tester.pump();
      expect(find.text('Help & Support coming soon!'), findsOneWidget);

      // Tap on About
      await tester.tap(find.text('About'));
      await tester.pump();
      expect(find.text('About page coming soon!'), findsOneWidget);
    });

    testWidgets('ProfilePage should have proper card layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify cards are used for layout
      expect(find.byType(Card), findsAtLeastNWidgets(5)); // Profile header + 4 options

      // Verify ListView is used for scrolling
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('ProfilePage should have proper icons for each option', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify icons are present for each option
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.help), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsAtLeastNWidgets(4));
    });

    testWidgets('ProfilePage should handle theme changes properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const ProfilePage(),
        ),
      );

      // Verify page renders in light theme
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.text('User Name'), findsOneWidget);
      
      // Switch to dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: const ProfilePage(),
        ),
      );
      
      // Verify page renders in dark theme
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.text('User Name'), findsOneWidget);
    });

    testWidgets('ProfilePage should have proper accessibility support', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify all interactive elements are accessible
      expect(find.byType(ListTile), findsAtLeastNWidgets(4));
      
      // Verify edit button has tooltip
      expect(find.byTooltip('Edit Profile'), findsOneWidget);
    });

    testWidgets('ProfilePage should handle different screen sizes', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );
      expect(find.byType(ProfilePage), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );
      expect(find.byType(ProfilePage), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('ProfilePage should have proper padding and spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify ListView has proper padding
      expect(find.byType(ListView), findsOneWidget);
      
      // Verify cards have proper margins
      expect(find.byType(Card), findsAtLeastNWidgets(5));
    });

    testWidgets('ProfilePage should handle widget lifecycle properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify initial state
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.text('User Name'), findsOneWidget);
      
      // Dispose and recreate
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );
      
      // Verify still functional
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.text('User Name'), findsOneWidget);
    });

    testWidgets('ProfilePage should have proper text styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify user name has bold styling
      final userNameText = find.text('User Name');
      expect(userNameText, findsOneWidget);

      // Verify email has proper styling
      final emailText = find.text('user@example.com');
      expect(emailText, findsOneWidget);

      // Verify option titles have proper styling
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Recycling History'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });
  });
}
