// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/predict_task_warn.dart';
import 'dart:math';
import 'package:boxicons/boxicons.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

List<Item> items = [const Item(name: "add more todos", index: "-1")];

TextStyle _newTextStyle() {
  return const TextStyle(fontFamily: "PT Serif", fontSize: 20);
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

typedef ListAddCallback = Function();

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  //Got rid of the initialized Button Styles to make more concise theme
  int _selectedIndex = 0;
  PredictTaskWarn ptw = PredictTaskWarn();
  Color eightball = Color.fromARGB(255, 62, 118, 253);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    final random = Random();
    var magic8 = [
      " - Yes, Definitely",
      " - Without a Doubt",
      " - Signs Point to Yes",
      " - Maybe",
      " - Outlook not so good",
      " - Very Doubtful"
    ];

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(style: _newTextStyle(), 'Item To Add'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: "type something here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: ElevatedButton.styleFrom(
                    textStyle: _newTextStyle(), backgroundColor: eightball),
                child: const Text("Ok"),
                onPressed: () {
                  if (valueText != "") {
                    setState(() {
                      _handleNewItem(valueText + magic8[random.nextInt(6)]);
                      Navigator.pop(context);
                      valueText = "";
                    });
                  }
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: ElevatedButton.styleFrom(
                        textStyle: _newTextStyle(),
                        backgroundColor: Colors.red),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("Cancel"),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  final _itemSet = <Item>{};

  int numCompleted = 0;

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
        numCompleted++;
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
        numCompleted--;
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText, index: "-1");
      items.insert(0, item);
      _inputController.clear();
    });
  }

  // When you click on a bottom nav bar item,
  // this goes into the PredictTaskWarn and creates the task

  // the ptw now takes index rather than the unreliable _selectedIndex
  // Apparently, something happens where _selectedIndex does not get updated properly,
  // so when some order of tasks, predictions, and warnings are made,
  // _selectedIndex loses track and causes one of the other things to appear
  // instead of the one that was most recently tapped.
  void _onItemTapped(int index) {
    setState(() {
      Random rand = Random();
      _selectedIndex = index;
      String name = ptw.ptw(index, rand);
      Item item = Item(name: name, index: "$index");
      items.insert(0, item);
      print(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: eightball,
          title: Text(style: _newTextStyle(), 'Items completed: $numCompleted'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: eightball,
            onPressed: () {
              _displayTextInputDialog(context);
            },
            child: const Icon(Icons.add)),
        //This where all of the predict things happen
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Boxicons.bxs_brain),
              label: 'Predict',
            ),
            BottomNavigationBarItem(
              icon: Icon(BootstrapIcons.list_task),
              label: 'Task',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning_amber),
              label: 'Warn',
            ),
          ],
          //When an item gets selected we go into a function where we save the index and use that to create the tasks
          currentIndex: _selectedIndex,
          //Changed the color to be more in line with magic 8 ball
          selectedItemColor: eightball,
          onTap: _onItemTapped,
        ));
  }
}

void main() {
  runApp(MaterialApp(
    title: 'To Do List',
    theme: ThemeData(textTheme: TextTheme(titleMedium: _newTextStyle())),
    home: ToDoList(),
  ));
}

// "You could have the app be a fortune recorder,
//  so the magic 8 ball is the way you get to add things to the list?"

// Have a class that holds a huge list of "predictions", "tasks", and "warnings"
// - When you press the button on the bottom,
//    it will add a new item to the list from that list.
// If you manually type something into the task list,
//  append a magic eight ball saying to the end of the to do item.
