// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/to_do_items.dart';

void main() {
  test('Workout abbreviation should be first letter', () {
    Workout workout = Workout(name: "Backsquat", reps: "3", sets: "5");
    expect(workout.abbrev(), "B");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('Each workout has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: ToDoListItem(
          workout: Workout(name: "test", reps: "3", sets: "5"),
          completed: true,
          onListChanged: (Workout workout, bool completed) {},
          onDeleteItem: (Workout item) {},
          displayEditDialog: (Workout workout) {}),
    )));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Each workout has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
      workout: Workout(name: "test", reps: "3", sets: "5"),
      completed: true,
      onListChanged: (Workout workout, bool completed) {},
      onDeleteItem: (Workout item) {},
      displayEditDialog: (Workout workout) {},
    ))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black54);
    expect(ctext.data, "t");
  });

  testWidgets('Default Workout has example', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to Workout Creator',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);
    expect(find.text("5"), findsNothing);
    expect(find.text("10"), findsNothing);

    await tester.enterText(find.byKey(const Key('exKey')), 'hi');
    await tester.enterText(find.byKey(const Key('setsKey')), '5');
    await tester.enterText(find.byKey(const Key('repsKey')), '10');

    await tester.pump();

    expect(find.text("hi"), findsOneWidget);
    expect(find.text("5"), findsOneWidget);
    expect(find.text("10"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OkButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  /*
  UNIT TESTS TO ADD:
  1) Editing pops up and disappears correctly
  2) Test editing
  3) Make sure deleting items work
  */

  testWidgets("Editing Dialog displays and disappears correctly.",
      (tester) async {
    // Build the app.
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    // Find the button to prompt Edit Dialog.
    await tester.tap(find.byKey(const Key("Edit Button")));

    // Wait for the app to update.
    await tester.pumpAndSettle();

    // Finds and taps the "Cancel" button in the Edit Dialog.
    await tester.tap(find.byKey(const Key("Edit Cancel Button")));

    // Wait for the app to update.
    await tester.pumpAndSettle();
  });

  testWidgets("Deleting items works.", (tester) async {
    // Build the app.
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    // There should be 1 delete button for the Example exercise automatically
    // added to the app.
    expect(find.byKey(const Key("Delete Button")), findsOneWidget);

    // Tap the delete button, trigger a frame and wait to settle.
    await tester.tap(find.byKey(const Key("Delete Button")));
    await tester.pumpAndSettle();

    // Because there are no items in the list, a delete button will not be
    // found.
    expect(find.byKey(const Key("Delete Button")), findsNothing);
  });

  testWidgets("Able to edit items successfully.", (tester) async {
    // Build the app.
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    // Tap the edit button, trigger a frame and settle.
    await tester.tap(find.byKey(const Key("Edit Button")));
    await tester.pumpAndSettle();

    // Tap the edit name field, edit the text field, trigger a frame and settle.
    await tester.tap(find.byKey(const Key("Edit Name Field")));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key("Edit Name Field")), "Workout 2");
    await tester.pumpAndSettle();

    // Tap the OK Button, trigger a frame and settle.
    await tester.tap(find.byKey(const Key("Edit OK Button")));
    await tester.pumpAndSettle();

    // Assert the name of the item was changed.
    expect(find.text("Workout 2"), findsOneWidget);
  });
}
