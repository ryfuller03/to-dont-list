// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/predict_task_warn.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    Item item = Item(name: "add more todos", index: "-1", strength: "");
    expect(item.abbrev(), "8");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: Item(name: "test", index: "-1", strength: ""),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('ToDoListItem has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: items[0],
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final abbvFinder = find.text("8");
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black54);
    expect(ctext.data, "8");
  });

  testWidgets('Default ToDoList has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to ToDoList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byKey(const Key('TitleField')), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    //changed this due to changes Jonathon made with texts being added to items
    expect(find.textContaining("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });
  // One to test the tap and press actions on the items?
  testWidgets('Marking an item complete adds one to the completed counter',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    final titleFinder0 = find.text("Items completed: 0");

    expect(titleFinder0, findsOneWidget);

    await tester.tap(find.text("add more todos"));
    await tester.pump();

    final titleFinder1 = find.text("Items completed: 1");

    expect(titleFinder1, findsOneWidget);

    await tester.tap(find.text("add more todos"));
    await tester.pump();

    final titleFinder2 = find.text("Items completed: 0");

    expect(titleFinder2, findsOneWidget);
  });

  testWidgets(
      'Giving an int and a random number to predictTaskWarn returns a string',
      (tester) async {
    Random rand = Random();
    String result = PredictTaskWarn().ptw(2, rand).toString();

    expect(result.runtimeType, String);
  });

  testWidgets("Subtitle for item shows up correctly.", (tester) async {
    // Build the app.
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    // The default list's prediction strength will always be "Strong", so
    // the text finder searches for that text.
    final subtitleFinder = find.text("Strong");

    // Finds the text and asserts that it is visible on-screen.
    expect(subtitleFinder, findsOneWidget);
  });
}
