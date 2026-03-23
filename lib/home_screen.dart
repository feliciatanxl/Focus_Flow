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

  // --- RESTORED TIMER TO THE MAIN PAGE LIST ---
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
      extendBody: true,
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      body: _pages[_selectedIndex],

      // --- MONOCHROME GLASS NAV BAR ---
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8),
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed, // Essential for 6 items
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: isDark ? Colors.white : Colors.black,
              unselectedItemColor: isDark ? Colors.white30 : Colors.black26,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedFontSize: 9, // Smaller font to fit 6 items
              unselectedFontSize: 9,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded, size: 20), label: 'HUB'),
                BottomNavigationBarItem(icon: Icon(Icons.terminal_rounded, size: 20), label: 'MATRIX'),
                BottomNavigationBarItem(icon: Icon(Icons.blur_on_rounded, size: 20), label: 'TIME'),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, size: 20), label: 'NODE'),
                BottomNavigationBarItem(icon: Icon(Icons.tune_rounded, size: 20), label: 'CONFIG'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// THE MONOCHROME HUB (Dashboard)
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
    {'name': 'System Optimization', 'isDone': true},
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

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final accentColor = isDark ? Colors.white : Colors.black;

    int completedTasks = _tasks.where((t) => t['isDone']).length;
    double progress = _tasks.isEmpty ? 0.0 : completedTasks / _tasks.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: isDark ? Colors.black : const Color(0xFFF5F5F5),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
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
                                'OPERATOR: ALEX',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Directives',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          _buildDateBadge(isDark, accentColor),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // XP BAR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('LVL 12 SCHOLAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: accentColor)),
                          Text('${(progress * 100).toInt()}% COMPLETED', style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: isDark ? Colors.white10 : Colors.black12,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(color: accentColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- STATS ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                  child: Row(
                    children: [
                      _buildStat('PENDING', '${_tasks.length - completedTasks}', isDark, accentColor),
                      const SizedBox(width: 12),
                      _buildStat('STREAK', '14', isDark, accentColor),
                    ],
                  ),
                ),

                // --- TASK LIST ---
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return _buildTaskCard(task, index, isDark, accentColor);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? Colors.white : Colors.black,
        foregroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () => _showAddTaskDialog(isDark, accentColor),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildDateBadge(bool isDark, Color accent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('MAR', style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black54, fontWeight: FontWeight.bold)),
          Text('23', style: TextStyle(fontSize: 18, color: accent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, bool isDark, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accent)),
            Text(label, style: TextStyle(fontSize: 9, letterSpacing: 1, color: isDark ? Colors.white38 : Colors.black38)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index, bool isDark, Color accent) {
    bool isDone = task['isDone'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDone ? Colors.transparent : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => task['isDone'] = !isDone),
                  child: Container(
                    height: 24, width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isDone ? Colors.transparent : accent, width: 2),
                      color: isDone ? accent : Colors.transparent,
                    ),
                    child: isDone ? Icon(Icons.check, size: 16, color: isDark ? Colors.black : Colors.white) : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    // Tap text to open Timer Screen
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TimerScreen(taskName: task['name'])));
                    },
                    child: Text(
                      task['name'],
                      style: TextStyle(
                        color: isDone ? (isDark ? Colors.white24 : Colors.black26) : accent,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        fontWeight: isDone ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white12 : Colors.black12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(bool isDark, Color accent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isDark ? Colors.white10 : Colors.transparent)),
        title: Text('NEW DIRECTIVE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: accent)),
        content: TextField(
          controller: _textController,
          autofocus: true,
          style: TextStyle(color: accent),
          decoration: InputDecoration(
            hintText: 'Input task...',
            hintStyle: const TextStyle(color: Colors.white24),
            border: UnderlineInputBorder(borderSide: BorderSide(color: accent)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ABORT', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38))),
          TextButton(onPressed: () { _addTask(); Navigator.pop(context); }, child: Text('CONFIRM', style: TextStyle(color: accent, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}