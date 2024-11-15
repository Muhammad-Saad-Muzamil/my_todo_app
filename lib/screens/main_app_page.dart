import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For converting data to/from JSON

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  final Map<String, String> _iconMap = {
    'home': 'assets/polarbear.jpg',
    'work': 'assets/elephant.png',
    'school': 'assets/parrot.png',
    // Add more image paths as needed
  };

  List<List<dynamic>> _todoItems = [];

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  // Load the to-do items from shared preferences
  Future<void> _loadTodoItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedTodos = prefs.getString('todo_items');
    if (savedTodos != null) {
      setState(() {
        _todoItems = List<List<dynamic>>.from(
          jsonDecode(savedTodos).map((item) => List<dynamic>.from(item))
        );
      });
    }
  }

  // Save the to-do items to shared preferences
  Future<void> _saveTodoItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todo_items', jsonEncode(_todoItems));
  }

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        String imagePath = 'assets/parrot.png'; // Default image if no match is found
        for (String key in _iconMap.keys) {
          if (task.toLowerCase().contains(key)) {
            imagePath = _iconMap[key]!;
            break;
          }
        }
        _todoItems.add([task, imagePath]);
      });
      _saveTodoItems(); // Save changes
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
    _saveTodoItems(); // Save changes
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark "${_todoItems[index][0]}" as done?'),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('MARK AS DONE'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 163, 64, 255),
            child: Image.asset(
              _todoItems[index][1],
              width: 24, // Adjust the width as needed
              height: 24, // Adjust the height as needed
            ),
          ),
          title: Text(_todoItems[index][0]),
          onTap: () => _promptRemoveTodoItem(index),
        );
      },
    );
  }

  Widget _buildAddTodoButton() {
    return FloatingActionButton(
      onPressed: _pushAddTodoScreen,
      tooltip: 'Add task',
      child: Icon(Icons.add),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add a new task'),
            ),
            body: TextField(
              autofocus: true,
              onSubmitted: (val) {
                _addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: _buildTodoList(),
      floatingActionButton: _buildAddTodoButton(),
    );
  }
}
