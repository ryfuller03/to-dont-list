import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class Item {
  Item({required this.name, required this.index, required this.strength});

  final String name;
  final String index;
  String strength;

  Item(this.name, this.hourCounter);

  String abbrev() {
    return "8";
  }

  String updateHourCounter(int amount) {
    if (hourCounter + amount < 0) {
      amount = -hourCounter;
    }
    return (hourCounter += amount).toString();
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);
typedef CounterUpdateCallback = Function(Item item, int amount);

class TrailingButtonsWidget extends StatelessWidget {
  const TrailingButtonsWidget({
    super.key,
    required this.item,
    required this.onCounterUpdate,
  });

  final Item item;
  final CounterUpdateCallback onCounterUpdate;

  Color _getColor() {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.
    if (completed) {
      return Colors.black54;
    } else if (item.index == "0") {
      return Colors.pinkAccent;
    } else if (item.index == "1") {
      return Colors.blue;
    } else if (item.index == "2") {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  Widget? _getIcon() {
    if (item.index == "0") {
      return const Icon(Boxicons.bxs_brain);
    } else if (item.index == "1") {
      return const Icon(BootstrapIcons.list_task);
    } else if (item.index == "2") {
      return const Icon(Icons.warning_amber);
    } else {
      return Text(item.abbrev());
    }
  }

  void onUpArrowLongPress() {
    onCounterUpdate(item, 10);
  }

    return const TextStyle(
      color: Colors.black54,
      //Changed it so that crossed out items turn into italics and changed the font for graphics reasons
      fontStyle: FontStyle.italic,
      fontFamily: "PT Serif",
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      TextButton(
        onPressed: onUpArrowTap,
        onLongPress: onUpArrowLongPress,
        child: const Icon(Icons.arrow_upward,
            color: Color.fromARGB(255, 166, 30, 50)),
      ),
      TextButton(
        onPressed: onDownArrowTap,
        onLongPress: onDownArrowLongPress,
        child: const Icon(Icons.arrow_downward,
            color: Color.fromARGB(255, 166, 30, 50)),
      ),
    ]);
  }
}

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.onDeleteItem,
      required this.onCounterUpdate})
      : super(key: ObjectKey(item));

  final Item item;
  final ToDoListRemovedCallback onDeleteItem;
  final CounterUpdateCallback onCounterUpdate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onListChanged(item, completed);
        },
        onLongPress: completed
            ? () {
                onDeleteItem(item);
              }
            : null,
        leading: CircleAvatar(
          backgroundColor: _getColor(),
          child: _getIcon(),
        ),
        title: Text(
          item.name,
          style: _getTextStyle(context),
        ),
        subtitle: Text(item.strength));
  }
}
