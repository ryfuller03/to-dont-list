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
    const workout = Workout(name: "Backsquat", reps: "3", sets: "5");
    expect(workout.abbrev(), "B");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('Each workout has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                workout: const Workout(name: "test", reps: "3", sets: "5"),
                completed: true,
                onListChanged: (Workout workout, bool completed) {},
                onDeleteItem: (Item item) {}))));
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
                workout: const Workout(name: "test", reps: "3", sets: "5"),
                completed: true,
                onListChanged: (Workout workout, bool completed) {},
                onDeleteItem: (Item item) {}))));
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

    await tester.enterText(find.byKey(Key('exKey')), 'hi');
    await tester.enterText(find.byKey(Key('setsKey')), '5');
    await tester.enterText(find.byKey(Key('repsKey')), '10');

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

  // One to test the tap and press actions on the items?
}
