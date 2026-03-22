import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 0;
  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final String _selectedColor = 'blue';

  Map<int, List<Map<String, String>>> _weeklySchedule = {
    0: [{'course': 'Intro to Computer Science', 'time': '09:00 AM - 10:30 AM', 'room': 'Room 402', 'color': 'blue'}],
    1: [{'course': 'Physics 101', 'time': '10:00 AM - 11:30 AM', 'room': 'Lab 3', 'color': 'green'}],
    2: [{'course': 'Calculus I', 'time': '11:00 AM - 12:30 PM', 'room': 'Hall B', 'color': 'orange'}],
    3: [], 4: [], 5: [], 6: [],
  };

  void _addClassManually() {
    if (_courseController.text.isNotEmpty && _timeController.text.isNotEmpty) {
      setState(() {
        _weeklySchedule[_selectedDayIndex]!.add({
          'course': _courseController.text,
          'time': _timeController.text,
          'room': _roomController.text.isEmpty ? 'TBA' : _roomController.text,
          'color': _selectedColor,
        });
      });
      _courseController.clear();
      _timeController.clear();
      _roomController.clear();
      Navigator.pop(context);
    }
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'blue': return Colors.blueAccent;
      case 'orange': return Colors.orangeAccent;
      case 'green': return Colors.green;
      case 'purple': return Colors.deepPurpleAccent;
      default: return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final dailyClasses = _weeklySchedule[_selectedDayIndex] ?? [];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HEADER (Back to clean style) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Schedule',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.calendar_month_rounded, color: isDark ? Colors.white : Colors.black87),
                  )
                ],
              ),
            ),

            // --- 2. DAY PICKER ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: List.generate(_daysOfWeek.length, (index) {
                  bool isSelected = _selectedDayIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDayIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blueAccent : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(_daysOfWeek[index], style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : (isDark ? Colors.grey : Colors.black54))),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // --- 3. CLASS LIST ---
            Expanded(
              child: dailyClasses.isEmpty
                  ? Center(child: Text('Free Day! Tap + to add a class.', style: TextStyle(color: isDark ? Colors.grey : Colors.black45)))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                itemCount: dailyClasses.length,
                itemBuilder: (context, index) {
                  final course = dailyClasses[index];
                  final cardColor = _getColor(course['color']!);

                  return GestureDetector(
                    onLongPress: () {
                      setState(() => _weeklySchedule[_selectedDayIndex]!.removeAt(index));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Row(
                          children: [
                            Container(width: 8, height: 110, color: cardColor),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(course['course']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
                                    const SizedBox(height: 12),
                                    Row(children: [Icon(Icons.access_time, size: 16, color: cardColor), const SizedBox(width: 8), Text(course['time']!, style: TextStyle(color: isDark ? Colors.grey : Colors.black54))]),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

      // --- 4. GROUPED FLOATING BUTTONS ---
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // THE MANUAL ADD BUTTON (+)
          FloatingActionButton(
            heroTag: 'add_manual', // Unique tag to prevent errors
            onPressed: () => _showAddClassDialog(isDark),
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 12),
          // THE SYLLABUS UPLOAD BUTTON
          FloatingActionButton.extended(
            heroTag: 'upload_syllabus',
            onPressed: () {},
            backgroundColor: Colors.deepPurpleAccent,
            icon: const Icon(Icons.document_scanner_rounded, color: Colors.white),
            label: const Text('Upload PDF', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddClassDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Add New Class', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField(_courseController, 'Course Name', Icons.book, isDark),
            _buildField(_timeController, 'Time', Icons.timer, isDark),
            _buildField(_roomController, 'Room Number', Icons.room, isDark),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: _addClassManually, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent), child: const Text('Add', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: isDark ? Colors.black26 : Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}