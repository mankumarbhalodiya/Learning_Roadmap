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

  testWidgets('ExploreScreen has search without any filter options', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ExploreScreen(),
      ),
    );

    // 1. Initial Explore View: Search bar and categories are visible, NO filter icon or chips
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search skills, roadmaps, topics...'), findsOneWidget);
    expect(find.text('All Roadmaps by Category'), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsNothing);
    expect(find.byType(FilterChip), findsNothing);
    expect(find.text('Recent Searches'), findsNothing);
    expect(find.text('Trending Roadmaps'), findsNothing);

    // 2. Click on the search field: Enters search mode!
    await tester.tap(find.byType(TextField));
    await tester.pump(const Duration(milliseconds: 100));

    // Now Recent Searches & Trending Roadmaps appear, still NO filter options
    expect(find.text('Recent Searches'), findsOneWidget);
    expect(find.text('Trending Roadmaps'), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsNothing);
    expect(find.byType(FilterChip), findsNothing);

    // 3. Type in the search field
    await tester.enterText(find.byType(TextField), 'Flutter');
    await tester.pump(const Duration(milliseconds: 100));

    // Search results appear
    expect(find.text('Flutter Developer'), findsOneWidget);

    // 4. Click back button in search bar: Exits search mode and restores normal explore view
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('All Roadmaps by Category'), findsOneWidget);
    expect(find.text('Recent Searches'), findsNothing);
    expect(find.text('Trending Roadmaps'), findsNothing);
  });
}
