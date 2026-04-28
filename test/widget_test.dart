import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_mvvm_app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Todo app smoke test', (WidgetTester tester) async {
    // Initialize SharedPreferences with mock values
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that our app starts with the correct title.
    expect(find.text('Todo App'), findsOneWidget);

    // Verify that the empty list is shown (no ListTiles yet)
    expect(find.byType(ListTile), findsNothing);

    // Tap the '+' icon to open the add dialog
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify the dialog is shown
    expect(find.text('Add Todo'), findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(find.byType(TextField).last, 'New Task');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify the new task is in the list
    expect(find.text('New Task'), findsOneWidget);
  });
}
