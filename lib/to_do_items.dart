import 'package:flutter/material.dart';

class Item {
  final String name;
  int hourCounter = 0;

  Item(this.name, this.hourCounter);

  String abbrev() {
    return name.substring(0, 1);
  }

  String incrementHourCounter() {
    return (hourCounter += 1).toString();
  }

  String decrementHourCounter() {
    return (hourCounter -= 1).toString();
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem,
      required this.onIncrementCounter,
      required this.onDecrementCounter})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;
  final ToDoListRemovedCallback onIncrementCounter;
  final ToDoListRemovedCallback onDecrementCounter;

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
      trailing: PopupMenuButton(
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
              child: const Text("Add 1 Hour"),
              onTap: () {
                item.incrementHourCounter();
                print(item.hourCounter);
              }),
          PopupMenuItem(
              child: const Text("Subtract 1 Hour"),
              onTap: () => item.decrementHourCounter())
        ],
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
