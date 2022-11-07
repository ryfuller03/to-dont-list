import 'package:flutter/material.dart';

class Item {
  const Item({required this.name});

  final String name;

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(Workout workout, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem({
    required this.workout,
    required this.completed,
    required this.onListChanged,
    required this.onDeleteItem,
  }) : super(key: ObjectKey(workout));

  final Workout workout;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  /* new dialog for edit button. What it needs to do:
    - Take in workout with its info
    - Autofill workout info in each text box
    - Save the changes after it's done
  */
  Future<void> _displayEditWorkoutDialog(
      BuildContext context, Workout workout) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Edit ${workout.name}"),
              content: Column(
                  mainAxisSize: MainAxisSize.min, children: [TextField()]));
        });
  }

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
        trailing: ElevatedButton(
            onPressed: () => _displayEditWorkoutDialog(context, workout),
            child: const Text("Edit")));
  }
}

class Workout {
  const Workout({required this.name, required this.reps, required this.sets});
  final String name;
  final String sets;
  final String reps;

  String abbrev() {
    return name.substring(0, 1);
  }
}
