import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'calendar_screen.dart';
import 'schedule_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TodoListScreen(), // 0: Home
    const ScheduleScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: isDark ? Colors.grey[600] : Colors.grey[400],
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

// 2. THE UPGRADED TO-DO LIST
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // Tasks are Maps so they can be "checked off"
  final List<Map<String, dynamic>> _tasks = [
    {'name': 'Read Chapter 4', 'isDone': false},
    {'name': 'Finish Math Homework', 'isDone': false},
  ];

  final TextEditingController _textController = TextEditingController();

  void _addTask() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _tasks.add({'name': _textController.text, 'isDone': false});
        _textController.clear();
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['isDone'] = !_tasks[index]['isDone'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. SLEEK OVERSIZED HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Alex 👋',
                        style: TextStyle(fontSize: 16, color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Today\'s Focus',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // Premium Circular Date Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.blueAccent.withOpacity(0.2) : Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Text('OCT', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('24', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 20)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),

            // --- 2. THE TASK LIST ---
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 80, color: isDark ? Colors.grey[800] : Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('All caught up! 🎉', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                    const SizedBox(height: 8),
                    Text('Tap + to add a new task.', style: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400])),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  final isDone = task['isDone'];

                  return Dismissible(
                    key: Key(task['name'] + index.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteTask(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Task deleted!', style: TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: isDark ? Colors.grey[800] : Colors.black87,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    // The red trash can background
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 30),
                    ),

                    // THE TASK CARD
                    child: GestureDetector(
                      onTap: () {
                        // Tap the card to open the Focus Timer!
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimerScreen(taskName: task['name']),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDone
                                ? (isDark ? Colors.green.withOpacity(0.3) : Colors.green.withOpacity(0.5))
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 15, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          // THE CHECKBOX
                          leading: GestureDetector(
                            onTap: () => _toggleTask(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isDone ? Colors.green : (isDark ? Colors.grey[800] : Colors.blue[50]),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isDone ? Icons.check_rounded : Icons.circle_outlined,
                                color: isDone ? Colors.white : (isDark ? Colors.grey[400] : Colors.blueAccent),
                                size: 24,
                              ),
                            ),
                          ),
                          // THE TEXT
                          title: Text(
                            task['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isDone ? FontWeight.normal : FontWeight.bold,
                              decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                              color: isDone
                                  ? (isDark ? Colors.grey[600] : Colors.grey)
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          // THE PLAY TIMER ICON
                          trailing: Icon(
                            Icons.play_circle_fill_rounded,
                            color: isDone ? Colors.transparent : (isDark ? Colors.grey[700] : Colors.grey[300]),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // UPGRADED FLOATING ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                title: Text('Add a new task', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                content: TextField(
                  controller: _textController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: "e.g., Finish Math Homework",
                    hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      _addTask();
                      Navigator.pop(context);
                    },
                    child: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add_rounded, size: 32),
      ),
    );
  }
}