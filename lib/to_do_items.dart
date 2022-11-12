import 'package:flutter/material.dart';

typedef ToDoListChangedCallback = Function(Workout workout, bool completed);
typedef ToDoListRemovedCallback = Function(Workout workout);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.workout,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem,
      required this.displayEditDialog})
      : super(key: ObjectKey(workout));

  final Workout workout;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;
  final ToDoListRemovedCallback displayEditDialog;

  /* new dialog for edit button. What it needs to do:
    - Take in workout with its info
    - Autofill workout info in each text box
    - Save the changes after it's done
  */

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

  Future<void> _displayWorkoutInfo(BuildContext context) async {
    print("Showing information");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Exercise Info'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Exercise: ${workout.name}"),
              Text("Sets: ${workout.sets}"),
              Text("Reps: ${workout.reps}"),
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
          onListChanged(workout, completed);
        },
        onLongPress: () {
          _displayWorkoutInfo(context);
        },
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child: Text(workout.abbrev()),
        ),
        title: Text(
          workout.name,
          style: _getTextStyle(context),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(
              onPressed: () {
                displayEditDialog(workout);
              },
              key: const Key("Edit Button"),
              child: const Text("Edit")),
          TextButton(
              onPressed: () {
                onDeleteItem(workout);
              },
              child: const Text("X",
                  key: Key("Delete Button"),
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey)))
        ]));
  }
}

class Workout {
  Workout({required this.name, required this.reps, required this.sets});
  String name;
  String sets;
  String reps;

  String abbrev() {
    return name.substring(0, 1);
  }
}
