import 'dart:ui';
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

  // UPGRADED: Returns Neon colors in Dark Mode!
  Color _getColor(String colorName, bool isDark) {
    switch (colorName) {
      case 'blue': return isDark ? const Color(0xFF00E5FF) : Colors.blueAccent; // Cyber Cyan
      case 'orange': return isDark ? const Color(0xFFFF9100) : Colors.orangeAccent; // Neon Orange
      case 'green': return isDark ? const Color(0xFF00E676) : Colors.green; // Matrix Green
      case 'purple': return isDark ? const Color(0xFFD500F9) : Colors.deepPurpleAccent; // Synthwave Purple
      default: return isDark ? Colors.grey[400]! : Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? const Color(0xFF00E5FF) : Colors.blueAccent;
    final dailyClasses = _weeklySchedule[_selectedDayIndex] ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent, // Let the gradient show through
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
                // --- 2. HEADER ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Timeline Matrix', // Tech rename
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
                          color: isDark ? primaryColor.withOpacity(0.1) : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: isDark ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 10)] : [],
                        ),
                        child: Icon(Icons.schedule_rounded, color: isDark ? primaryColor : Colors.black87),
                      )
                    ],
                  ),
                ),

                // --- 3. GLASS DAY PICKER ---
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? primaryColor.withOpacity(0.15) : Colors.blueAccent)
                                      : (isDark ? Colors.white.withOpacity(0.03) : Colors.white),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isSelected
                                        ? primaryColor
                                        : (isDark ? Colors.white.withOpacity(0.1) : Colors.transparent),
                                    width: isSelected && isDark ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                    _daysOfWeek[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? (isDark ? primaryColor : Colors.white)
                                          : (isDark ? Colors.grey[500] : Colors.black54),
                                      letterSpacing: 1,
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // --- 4. GLASS CLASS LIST ---
                Expanded(
                  child: dailyClasses.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_available_rounded, size: 80, color: isDark ? Colors.grey[800] : Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('NO MODULES FOUND', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, color: isDark ? Colors.grey[500] : Colors.grey[600])),
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 120.0), // Extra bottom padding for FABs
                    itemCount: dailyClasses.length,
                    itemBuilder: (context, index) {
                      final course = dailyClasses[index];
                      final cardColor = _getColor(course['color']!, isDark);

                      return GestureDetector(
                        onLongPress: () {
                          setState(() => _weeklySchedule[_selectedDayIndex]!.removeAt(index));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white, width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    // Neon Colored Accent Bar
                                    Container(
                                      width: 8,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        boxShadow: isDark ? [BoxShadow(color: cardColor, blurRadius: 10)] : [],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                course['course']!,
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                                children: [
                                                  Icon(Icons.access_time_rounded, size: 16, color: cardColor),
                                                  const SizedBox(width: 8),
                                                  Text(course['time']!, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.black54, fontWeight: FontWeight.w500))
                                                ]
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                                children: [
                                                  Icon(Icons.location_on_rounded, size: 16, color: cardColor),
                                                  const SizedBox(width: 8),
                                                  Text(course['room']!, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.black54, fontWeight: FontWeight.w500))
                                                ]
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

      // --- 5. GROUPED NEON FLOATING BUTTONS ---
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // MANUAL ADD BUTTON (+)
          FloatingActionButton(
            heroTag: 'add_manual',
            onPressed: () => _showAddClassDialog(isDark, primaryColor),
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : primaryColor,
            foregroundColor: isDark ? primaryColor : Colors.white,
            elevation: isDark ? 10 : 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isDark ? BorderSide(color: primaryColor, width: 1.5) : BorderSide.none,
            ),
            child: const Icon(Icons.add_rounded, size: 30),
          ),
          const SizedBox(height: 12),

          // SYLLABUS UPLOAD BUTTON
          FloatingActionButton.extended(
            heroTag: 'upload_syllabus',
            onPressed: () {},
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFD500F9), // Cyber Purple
            foregroundColor: isDark ? const Color(0xFFD500F9) : Colors.white,
            elevation: isDark ? 10 : 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isDark ? const BorderSide(color: Color(0xFFD500F9), width: 1.5) : BorderSide.none,
            ),
            icon: const Icon(Icons.document_scanner_rounded),
            label: const Text('Upload PDF', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ),
        ],
      ),
    );
  }

  // --- FUTURISTIC ADD CLASS DIALOG ---
  void _showAddClassDialog(bool isDark, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: isDark ? BorderSide(color: primaryColor.withOpacity(0.5)) : BorderSide.none,
        ),
        title: Text('Insert Module', style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField(_courseController, 'Module Name', Icons.book_rounded, isDark, primaryColor),
            _buildField(_timeController, 'Time (10AM-12PM)', Icons.timer_rounded, isDark, primaryColor),
            _buildField(_roomController, 'Location', Icons.room_rounded, isDark, primaryColor),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey))
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
              onPressed: _addClassManually,
              child: const Text('Execute', style: TextStyle(fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, bool isDark, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: isDark ? primaryColor : Colors.blueAccent),
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 1.5)
          ),
        ),
      ),
    );
  }
}