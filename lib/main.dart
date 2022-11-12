// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final Key key1 = const Key("Exercise");
  final Key key2 = const Key("Sets");
  final Key key3 = const Key("Reps");
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add exercise'),
            content: Column(children: <Widget>[
              const Text("Exercise"),
              TextField(
                key: Key('exKey'),
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _inputController,
                decoration: const InputDecoration(hintText: "type"),
              ),
              const Text("Sets"),
              TextField(
                key: const Key('setsKey'),
                onChanged: (value2) {
                  setState(() {
                    sets = value2;
                  });
                },
                controller: _setsController,
                decoration: const InputDecoration(hintText: "type"),
              ),
              const Text("Reps"),
              TextField(
                key: Key('repsKey'),
                onChanged: (value3) {
                  setState(() {
                    reps = value3;
                  });
                },
                controller: _repsController,
                decoration: const InputDecoration(hintText: "type"),
              )
            ]),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OkButton"),
                style: yesStyle,
                child: const Text('Add'),
                onPressed: () {
                  setState(() {
                    _handleNewItem(valueText, sets, reps);
                    Navigator.pop(context);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayEditWorkoutDialog(Workout workout) async {
    int newReps = 0; // set to 0 initially for int.tryParse to catch errors
    int newSets = 0;
    if (int.tryParse(workout.reps) == null) {
      newReps = 0;
    } else {
      newReps = int.parse(workout.reps);
    }
    if (int.tryParse(workout.sets) == null) {
      newSets = 0;
    } else {
      newSets = int.parse(workout.sets);
    }
    String newName =
        workout.name; // set to workout.name initially to avoid errors
    final ButtonStyle yesStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.green);
    final ButtonStyle noStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Edit ${workout.name}"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("Edit Name:"),
                TextField(
                    key: const Key("Edit Name Field"),
                    onChanged: (value) {
                      newName = value;
                    },
                    controller: TextEditingController(text: workout.name),
                    decoration: const InputDecoration(hintText: "Name")),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text("Edit Sets:"),
                TextField(
                    onChanged: (value2) {
                      if (int.tryParse(value2) != null) {
                        newSets = int.parse(value2);
                      } else {}
                      ;
                    },
                    controller: TextEditingController(text: workout.sets),
                    decoration: const InputDecoration(hintText: "Sets")),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text("Edit Reps:"),
                TextField(
                    onChanged: (value3) {
                      if (int.tryParse(value3) != null) {
                        newReps = int.parse(value3);
                      }
                    },
                    controller: TextEditingController(text: workout.reps),
                    decoration: const InputDecoration(hintText: "Reps")),
              ]),
              actions: <Widget>[
                ElevatedButton(
                    key: const Key("Edit OK Button"),
                    style: yesStyle,
                    child: const Text("OK"),
                    onPressed: () {
                      setState(() {
                        _handleEditItem(newName, newSets, newReps, workout);
                        Navigator.pop(context);
                      });
                    }),
                ElevatedButton(
                    key: const Key("Edit Cancel Button"),
                    style: noStyle,
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("Cancel"))
              ]);
        });
  }

  String valueText = "";

  String sets = "";

  String reps = "";

  final List<Workout> workouts = [
    Workout(name: "Example", reps: "5", sets: "3")
  ];

  final _workoutSet = <Workout>{};

  void _handleListChanged(Workout workout, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      workouts.remove(workout);
      if (!completed) {
        print("Completing");
        _workoutSet.add(workout);
        workouts.add(workout);
      } else {
        print("Making Undone");
        _workoutSet.remove(workout);
        workouts.insert(0, workout);
      }
    });
  }

  void _handleDeleteItem(Workout workout) {
    setState(() {
      workouts.remove(workout);
    });
  }

  void _handleNewItem(String itemText, String set, String rep) {
    setState(() {
      print("Adding new item");
      Workout workout_base = Workout(name: itemText, reps: rep, sets: set);
      workouts.insert(0, workout_base);
      _inputController.clear();
      _setsController.clear();
      _repsController.clear();
    });
  }

  void _handleEditItem(
      String newName, int newSets, int newReps, Workout workout) {
    setState(() {
      workout.name = newName;
      workout.sets = newSets.toString();
      workout.reps = newReps.toString();
      // clear all controllers for text fields
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Creator'),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: workouts.map((workout) {
            return ToDoListItem(
                workout: workout,
                completed: _workoutSet.contains(workout),
                onListChanged: _handleListChanged,
                onDeleteItem: _handleDeleteItem,
                displayEditDialog: _displayEditWorkoutDialog);
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}
