import 'package:flutter/material.dart';

class Item {
  final String name;
  int hourCounter = 0;

  Item(this.name, this.hourCounter);

  String abbrev() {
    return name.substring(0, 1);
  }

  String updateHourCounter(int amount) {
    if (hourCounter + amount < 0) { amount = -hourCounter; }
    return (hourCounter += amount).toString();
  }

  String decrementBy10() {
    if (hourCounter - 10 < 0) {
      //This will reset the counter to 0 if the long press subtraction by 10 is below 0
      return (hourCounter -= hourCounter).toString();
    }
    return (hourCounter -= 10).toString();
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);
typedef CounterUpdateCallback = Function(Item item, int amount);

class TrailingButtonsWidget extends StatelessWidget {
  TrailingButtonsWidget(
      {super.key,
      required this.item,
      required this.onCounterUpdate,});

  final Item item;
  final CounterUpdateCallback onCounterUpdate;

  void ButtonsIncrementHourCounter() {
    onCounterUpdate(item, 1);
  }

  void ButtonsDecrementHourCounter() {
    onCounterUpdate(item, -1);
  }

  void ButtonsIncrement10Counter() {
    onCounterUpdate(item, 10);
  }

  void ButtonsDecrement10Counter() {
    onCounterUpdate(item, -10);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
      TextButton(
          child: Icon(Icons.arrow_upward),
          onPressed: ButtonsIncrementHourCounter,
          onLongPress: ButtonsIncrement10Counter),
      TextButton(
        child: Icon(Icons.arrow_downward),
        onPressed: ButtonsDecrementHourCounter,
        onLongPress: ButtonsDecrement10Counter,
      )
    ]));
  }
}

// FIGURE OUT HOW TO MAKE onIncrementCounter NOT TAKE IN A PARAMETER (put in ToDoListItem???)

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.completed,
      required this.onDeleteItem,
      required this.onCounterUpdate})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final ToDoListRemovedCallback onDeleteItem;
  final CounterUpdateCallback onCounterUpdate;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        onDeleteItem(item);
      },
      leading: CircleAvatar(
        // check off button
        backgroundColor: _getColor(context),
        child: Text(item.abbrev(), style: const TextStyle(color: Colors.white)),
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
      trailing: TrailingButtonsWidget(
        key: key,
        item: item,
        onCounterUpdate: onCounterUpdate,
      ),
      subtitle: Text("Hours: " + item.hourCounter.toString(),
          style: _getTextStyle(context)),
    );
  }
}
