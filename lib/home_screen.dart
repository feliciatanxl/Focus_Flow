import 'package:flutter/material.dart';

// 1. THE MASTER NAVIGATION SHELL
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This number tracks which tab is currently highlighted (starts at 0 for Home)
  int _selectedIndex = 0;

  // This is the "TV Guide" - a list of the 5 screens we can swap between
  final List<Widget> _pages = [
    const TodoListScreen(), // 0: Home (Your beautiful To-Do List!)
    const PlaceholderScreen(title: 'Calendar', icon: Icons.calendar_month), // 1: Calendar
    const PlaceholderScreen(title: 'Schedule', icon: Icons.schedule),       // 2: Schedule
    const PlaceholderScreen(title: 'Profile', icon: Icons.person),          // 3: Profile
    const PlaceholderScreen(title: 'Settings', icon: Icons.settings),       // 4: Settings
  ];

  // This function runs every time you tap a button on the bottom bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body swaps out the screen based on which tab you tapped
      body: _pages[_selectedIndex],

      // The Bottom Navigation Bar itself
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // CRITICAL: Required if you have more than 3 tabs!
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent, // Color when tapped
        unselectedItemColor: Colors.grey,     // Color when not tapped
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// 2. YOUR ORIGINAL TO-DO LIST (Now acting as Tab #0)
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> _tasks = [];
  final TextEditingController _textController = TextEditingController();

  void _addTask() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_textController.text);
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Today\'s Focus', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Hides the back button just in case
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(_tasks[index]),
              leading: const Icon(Icons.circle_outlined, color: Colors.blueAccent),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add a new task'),
                content: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(hintText: "e.g., Finish Math Homework"),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _addTask();
                      Navigator.pop(context);
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 3. A DUMMY SCREEN FOR YOUR OTHER TABS
// We use this so your app doesn't crash while you haven't built the other screens yet!
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              '$title Screen\nComing Soon!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}