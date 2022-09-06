import 'package:flutter/material.dart';

class Item {
  const Item({required this.name});

  final String name;

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);
typedef WorkoutInfo = Function(Workout workout);

class ToDoListItem extends StatelessWidget {
  ToDoListItem({
    required this.item,
    //required this.workout,
    required this.completed,
    required this.onListChanged,
    required this.onDeleteItem,
    //required this.info
  }) : super(key: ObjectKey(item));

  //final Workout workout;
  final Item item;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;
  //final WorkoutInfo info;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.none,
    );
  }

  void _displayInfo() {
    print("Back Squat");
    print("3 Sets");
    print("10 Reps Each");
  }

  Workout work = const Workout(reps: 15, sets: 3);

  Future<void> _displayWorkoutInfo(BuildContext context) async {
    print("Showing information");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Exercise Info'),
            content: Column(children: [
              Text("Exercise: ${item.name}"),
              Text("Sets: ${work.sets}"),
              Text("Reps: ${work.reps}"),
            ]),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("Leave"),
                child: const Text('Leave'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item, completed);
      },
      onLongPress: () {
        _displayWorkoutInfo(context);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(item.abbrev()),
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
    );
  }
}

class Workout {
  const Workout({required this.reps, required this.sets});
  final int sets;
  final int reps;
}
