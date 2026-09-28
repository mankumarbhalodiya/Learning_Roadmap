import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap/screens/explore/explore_screen.dart';
import 'package:roadmap/screens/main_nav_container.dart';
import 'package:roadmap/theme/app_theme.dart';

void main() {
  testWidgets('MainNavContainer has 4 tabs without Search in bottom nav', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MainNavContainer(),
      ),
    );

    // Verify 4 navigation tabs exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Roadmap'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Verify Search is not in the navigation items
    final bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(bottomNav.items.length, 4);
    expect(bottomNav.items.any((item) => item.label == 'Search'), isFalse);
  });

  testWidgets('ExploreScreen includes search bar and category filters', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ExploreScreen(),
      ),
    );

    // Verify search bar is present in explore
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search skills, roadmaps, topics...'), findsOneWidget);

    // Verify category chips in explore
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Software & Web'), findsOneWidget);

    // Test typing in search bar
    await tester.enterText(find.byType(TextField), 'Flutter');
    await tester.pump(const Duration(milliseconds: 100));

    // Verify search results appear
    expect(find.text('Flutter Developer'), findsOneWidget);
  });
}
