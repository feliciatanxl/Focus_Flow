import 'dart:ui';
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
    const TodoListScreen(),
    const ScheduleScreen(),
    const CalendarScreen(),
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
      extendBody: true, // Allows the body gradient to flow BEHIND the nav bar
      body: _pages[_selectedIndex],

      // --- GLASSMORPHIC BOTTOM NAV BAR ---
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF09090B).withOpacity(0.7) : Colors.white.withOpacity(0.8),
              border: Border(top: BorderSide(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05))),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: isDark ? const Color(0xFF00E5FF) : Colors.blueAccent,
              unselectedItemColor: isDark ? Colors.grey[600] : Colors.grey[400],
              backgroundColor: Colors.transparent, // Handled by container above
              elevation: 0,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Hub'),
                BottomNavigationBarItem(icon: Icon(Icons.schedule_rounded), label: 'Schedule'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Calendar'),
                BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Node'),
                BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Config'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// 2. THE FUTURISTIC HUB (To-Do List + Dashboard)
// -------------------------------------------------------------------------
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {'name': 'Compile Chapter 4 Notes', 'isDone': false},
    {'name': 'Execute Math Algorithms', 'isDone': false},
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
    final primaryColor = isDark ? const Color(0xFF00E5FF) : Colors.blueAccent;

    // Calculate progress for the XP Bar
    int completedTasks = _tasks.where((task) => task['isDone'] == true).length;
    double progress = _tasks.isEmpty ? 0.0 : completedTasks / _tasks.length;

    return Scaffold(
      body: Stack(
        children: [
          // --- 1. THE TECH GRADIENT BACKGROUND ---
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF09090B), const Color(0xFF13131A), const Color(0xFF09090B)]
                      : [const Color(0xFFF4F6F9), Colors.white, const Color(0xFFF4F6F9)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 2. HEADER & XP BAR ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SYSTEM USER: ALEX',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Active Directives',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          // Tech Date Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark ? primaryColor.withOpacity(0.1) : Colors.blue[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isDark ? primaryColor.withOpacity(0.3) : Colors.transparent),
                              boxShadow: isDark ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 10)] : [],
                            ),
                            child: Column(
                              children: [
                                Text('OCT', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                                Text('24', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 20)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),

                      // GAMIFIED XP BAR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lvl 12 Scholar', style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                          Text('${(progress * 100).toInt()}% to Level 13', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: isDark ? Colors.white10 : Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 3. BENTO DASHBOARD STATS ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Row(
                    children: [
                      _buildBentoStat('Pending', '${_tasks.length - completedTasks}', Icons.hourglass_empty_rounded, isDark, primaryColor),
                      const SizedBox(width: 12),
                      _buildBentoStat('Streak', '14', Icons.local_fire_department_rounded, isDark, Colors.orangeAccent),
                    ],
                  ),
                ),

                // --- 4. THE GLASSMORPHIC TASK LIST ---
                Expanded(
                  child: _tasks.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt_rounded, size: 80, color: isDark ? Colors.grey[800] : Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('QUEUE EMPTY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, color: isDark ? Colors.grey[500] : Colors.grey[600])),
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 100), // Bottom padding for FAB and Nav
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      final isDone = task['isDone'];

                      return Dismissible(
                        key: Key(task['name'] + index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteTask(index);
                        },
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 30),
                        ),

                        // GLASS TASK CARD
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TimerScreen(taskName: task['name'])));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isDone
                                        ? Colors.green.withOpacity(0.5)
                                        : (isDark ? Colors.white.withOpacity(0.1) : Colors.white),
                                    width: isDone ? 2 : 1.5,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  leading: GestureDetector(
                                    onTap: () => _toggleTask(index),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: isDone ? Colors.green : (isDark ? Colors.white10 : Colors.blue[50]),
                                        shape: BoxShape.circle,
                                        boxShadow: isDone && isDark ? [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 10)] : [],
                                      ),
                                      child: Icon(
                                        isDone ? Icons.check_rounded : Icons.circle_outlined,
                                        color: isDone ? Colors.white : primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    task['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isDone ? FontWeight.normal : FontWeight.bold,
                                      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                      color: isDone ? Colors.grey[600] : (isDark ? Colors.white : Colors.black87),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: isDone ? Colors.transparent : (isDark ? primaryColor.withOpacity(0.5) : Colors.grey[300]),
                                    size: 32,
                                  ),
                                ),
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
        ],
      ),

      // --- 5. NEON FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : primaryColor,
        foregroundColor: isDark ? primaryColor : Colors.white,
        elevation: isDark ? 10 : 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark ? BorderSide(color: primaryColor, width: 1.5) : BorderSide.none,
        ),
        onPressed: () => _showAddTaskDialog(isDark, primaryColor),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
    );
  }

  // Helper for Bento Stats
  Widget _buildBentoStat(String title, String value, IconData icon, bool isDark, Color color) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    Text(title, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[500] : Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Futuristic Dialog Box
  void _showAddTaskDialog(bool isDark, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: isDark ? BorderSide(color: primaryColor.withOpacity(0.5)) : BorderSide.none,
          ),
          title: Text('New Directive', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          content: TextField(
            controller: _textController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: "e.g., Debug algorithm",
              hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey),
              filled: true,
              fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.transparent : primaryColor,
                foregroundColor: isDark ? primaryColor : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isDark ? BorderSide(color: primaryColor) : BorderSide.none,
                ),
              ),
              onPressed: () {
                _addTask();
                Navigator.pop(context);
              },
              child: const Text('Execute', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}