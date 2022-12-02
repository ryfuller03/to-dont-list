import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Item {
  final String name;
  int hourCounter = 0;

  Item(this.name, this.hourCounter);

  String abbrev() {
    return name.substring(0, 1);
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

  void onUpArrowTap() {
    onCounterUpdate(item, 1);
  }

  void onDownArrowTap() {
    onCounterUpdate(item, -1);
  }

  void onUpArrowLongPress() {
    onCounterUpdate(item, 10);
  }

  void onDownArrowLongPress() {
    onCounterUpdate(item, -10);
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
      onLongPress: () {
        onDeleteItem(item);
      },
      leading: CircleAvatar(
        // check off button
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(item.abbrev(),
            style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.pressStart2p().fontFamily)),
      ),
      title: Text(item.name,
          style: TextStyle(
              fontFamily: GoogleFonts.vt323().fontFamily, fontSize: 22)),
      trailing: TrailingButtonsWidget(
        key: key,
        item: item,
        onCounterUpdate: onCounterUpdate,
      ),
      subtitle: Text("Hours: ${item.hourCounter}",
          style: TextStyle(
              fontFamily: GoogleFonts.vt323().fontFamily, fontSize: 18)),
    );
  }
}
