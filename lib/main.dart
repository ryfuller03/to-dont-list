// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_dont_list/to_do_items.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _numberInputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), 
      backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {

    String newGameName = "";
    int startingHourCount = 0;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Game'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  key: const Key('TitleField'),
                  onChanged: (value) {
                    setState(() {
                      newGameName = value;
                    });
                  },
                  controller: _nameInputController,
                  decoration: const InputDecoration(hintText: "Title"),
                ),
                TextField(
                  key: const Key('HourField'),
                  onChanged: (value) {
                    setState(() {
                      startingHourCount = 
                          int.tryParse(value) ?? startingHourCount;
                    });
                  },
                  controller: _numberInputController,
                  decoration: const InputDecoration(
                      hintText: "Initial hour count"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ],
            ),
            actions: <Widget>[

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameInputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value.text.isNotEmpty
                      ? () {
                          setState(() {
                            _handleNewItem(newGameName, startingHourCount);
                            Navigator.pop(context);
                          });
                        }
                      : null,
                    child: const Text('OK'),
                  );
                },
              ),
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  final List<Item> items = [Item("Add some games and track your hours!", 0)];

  final _itemSet = <Item>{};

  /// Sorts items in an order compatible with a ListView.
  void sortItemList() {    
    /// Sorts Items descending by hour count, then ascending by name.
    int compareItemsForListView(Item a, Item b) {
      int compareHours = b.hourCounter.compareTo(a.hourCounter);
      if (compareHours != 0) {
        return compareHours;
      } else {
        return a.name.compareTo(b.name);
      }
    }
    // thanks to stackoverflow.com/questions/53547997 and Dart docs
    items.sort(compareItemsForListView);
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText, int itemHours) {
    setState(() {
      Item item = Item(itemText, itemHours);
      items.insert(0, item);
      _nameInputController.clear();
      _numberInputController.clear();
      sortItemList();
    });
  }

  void _handleUpdateCounter(Item item, int amount) {
    setState(() {
      item.updateHourCounter(amount);
      sortItemList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Video Game Hour Tracker'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onDeleteItem: _handleDeleteItem,
              onCounterUpdate: _handleUpdateCounter,
            );
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
    title: 'Video Game Hour Tracker',
    home: ToDoList(),
  ));
}
