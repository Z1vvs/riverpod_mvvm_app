import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_mvvm_app/main.dart';
import 'package:riverpod_mvvm_app/presentation/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Integration test: Add todo and verify it appears in list', (WidgetTester tester) async {
    // Mock SharedPreferences for tests
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HomeView()),
      ),
    );

    // Verify that the list is initially empty
    expect(find.byType(ListTile), findsNothing);

    // Tap the add button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(); // Wait for animations and asynchronous operations to complete

    // Verify if the new task appeared (default "New Task")
    expect(find.text('New Task'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);

    // Verify the checkbox functionality
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // Can add text style check (strikethrough) if needed
  });
}
