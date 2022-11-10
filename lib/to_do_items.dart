import 'package:flutter/material.dart';

typedef ToDoListChangedCallback = Function(Workout workout, bool completed);
typedef ToDoListRemovedCallback = Function(Workout item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem({
    required this.workout,
    required this.completed,
    required this.onListChanged,
    required this.onDeleteItem,
    required this.onEditItem,
  }) : super(key: ObjectKey(workout));

  final Workout workout;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;
  // ignore: prefer_typing_uninitialized_variables
  final onEditItem;

  /* new dialog for edit button. What it needs to do:
    - Take in workout with its info
    - Autofill workout info in each text box
    - Save the changes after it's done
  */
  Future<void> _displayEditWorkoutDialog(
      BuildContext context, Workout workout) async {
    int newReps = 0;
    int newSets = 0;
    String newName = "";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Edit ${workout.name}"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("Edit Name:"),
                TextField(
                    onChanged: (value) => newName,
                    controller: TextEditingController(text: workout.name),
                    decoration: const InputDecoration(hintText: "Name")),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text("Edit Sets:"),
                TextField(
                    onChanged: (value) => newSets,
                    controller: TextEditingController(text: workout.sets),
                    decoration: const InputDecoration(hintText: "Sets")),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text("Edit Reps:"),
                TextField(
                    onChanged: (value) => newReps,
                    controller: TextEditingController(text: workout.reps),
                    decoration: const InputDecoration(hintText: "Reps")),
              ]));
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
  Workout({required this.name, required this.reps, required this.sets});
  String name;
  String sets;
  String reps;

  String abbrev() {
    return name.substring(0, 1);
  }
}
