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
  test('Item abbreviation should be first letter', () {
    Item item = Item("add more todos", 0);
    expect(item.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
      item: Item("test", 0),
      completed: true,
      onListChanged: (Item item, bool completed) {},
      onDeleteItem: (Item item) {},
      onIncrementCounter: (Item item) {},
      onDecrementCounter: (Item item) {},
      on10Increment: (Item item) {},
      on10Decrement: (Item item) {},
    ))));
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
      item: Item("test", 0),
      completed: true,
      onListChanged: (item, completed) => {},
      onDeleteItem: (item) => {},
      onIncrementCounter: (Item item) {},
      onDecrementCounter: (Item item) {},
      on10Increment: (Item item) {},
      on10Decrement: (Item item) {},
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

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  testWidgets(
      'TrailingButtonsWidget adds and subtracts from the Hours counter', // TrailingButtonsWidget class
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    await tester.tap(find.byIcon(Icons.arrow_upward)); // tests adding
    await tester.pump();
    expect(find.text("Hours: 1"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_downward)); // tests subtracting
    await tester.pump();
    expect(find.text("Hours: 0"), findsOneWidget);
  });

  testWidgets("TrailingButtonsWidget long press functionality", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));
    await tester.longPress(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    expect(find.text("Hours: 10"), findsOneWidget);

    await tester.longPress(find.byIcon(Icons.arrow_downward));
    await tester.pump();
    expect(find.text("Hours: 0"), findsOneWidget);
  });

  // One to test the tap and press actions on the items?
}
