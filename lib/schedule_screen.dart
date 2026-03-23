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

  Map<int, List<Map<String, String>>> _weeklySchedule = {
    0: [{'course': 'Intro to Computer Science', 'time': '09:00 AM - 10:30 AM', 'room': 'Room 402'}],
    1: [{'course': 'Physics 101', 'time': '10:00 AM - 11:30 AM', 'room': 'Lab 3'}],
    2: [{'course': 'Calculus I', 'time': '11:00 AM - 12:30 PM', 'room': 'Hall B'}],
    3: [], 4: [], 5: [], 6: [],
  };

  void _processSyllabusAI() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("AI MATRIX: INITIALIZING PDF PARSER...",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        backgroundColor: Provider.of<ThemeProvider>(context, listen: false).isDarkMode ? Colors.white : Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addClassManually() {
    if (_courseController.text.isNotEmpty && _timeController.text.isNotEmpty) {
      setState(() {
        _weeklySchedule[_selectedDayIndex]!.add({
          'course': _courseController.text,
          'time': _timeController.text,
          'room': _roomController.text.isEmpty ? 'TBA' : _roomController.text,
        });
      });
      _courseController.clear();
      _timeController.clear();
      _roomController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final accentColor = isDark ? Colors.white : Colors.black;
    final dailyClasses = _weeklySchedule[_selectedDayIndex] ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // --- 1. MONOCHROME BACKGROUND ---
          Positioned.fill(
            child: Container(
              color: isDark ? Colors.black : const Color(0xFFF5F5F5),
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
                        'Matrix',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                          color: accentColor,
                        ),
                      ),
                      Icon(Icons.grid_3x3_rounded, color: accentColor, size: 28),
                    ],
                  ),
                ),

                // --- 3. FIXED DAY PICKER (Mon - Sun) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: List.generate(_daysOfWeek.length, (index) {
                        bool isSelected = _selectedDayIndex == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedDayIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? accentColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                _daysOfWeek[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: isSelected
                                      ? (isDark ? Colors.black : Colors.white)
                                      : (isDark ? Colors.white38 : Colors.black38),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // --- 4. CLASS LIST ---
                Expanded(
                  child: dailyClasses.isEmpty
                      ? _buildEmptyState(isDark, accentColor)
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 180),
                    itemCount: dailyClasses.length,
                    itemBuilder: (context, index) {
                      final course = dailyClasses[index];
                      return _buildClassCard(course, isDark, accentColor, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // --- 5. STACKED HIGH-CONTRAST BUTTONS ---
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI SCAN BUTTON (White/Black Contrast)
          FloatingActionButton.extended(
            heroTag: 'ai_scan_btn',
            onPressed: _processSyllabusAI,
            backgroundColor: isDark ? Colors.white : Colors.black,
            foregroundColor: isDark ? Colors.black : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text("AI SCAN", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),

          const SizedBox(height: 12),

          // MANUAL ADD BUTTON
          FloatingActionButton(
            heroTag: 'manual_add_btn',
            onPressed: () => _showAddClassDialog(isDark, accentColor),
            backgroundColor: isDark ? Colors.white : Colors.black,
            foregroundColor: isDark ? Colors.black : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.add_rounded, size: 30),
          ),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildEmptyState(bool isDark, Color accent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.blur_off_rounded, size: 60, color: isDark ? Colors.white12 : Colors.black12),
          const SizedBox(height: 10),
          Text("IDLE", style: TextStyle(fontSize: 12, letterSpacing: 4, color: isDark ? Colors.white24 : Colors.black26, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildClassCard(Map<String, String> course, bool isDark, Color accent, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                // Minimalist White/Black side bar
                Container(width: 4, height: 45, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10))),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course['course']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: accent)),
                      const SizedBox(height: 4),
                      Text("${course['time']}  •  ${course['room']}", style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: isDark ? Colors.white24 : Colors.black26, size: 20),
                  onPressed: () => setState(() => _weeklySchedule[_selectedDayIndex]!.removeAt(index)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddClassDialog(bool isDark, Color accent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: BorderSide(color: isDark ? Colors.white10 : Colors.transparent)),
        title: Text("NEW MODULE", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: accent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField(_courseController, "MODULE NAME", isDark, accent),
            const SizedBox(height: 12),
            _buildDialogField(_timeController, "TIMESTAMP", isDark, accent),
            const SizedBox(height: 12),
            _buildDialogField(_roomController, "NODE LOCATION", isDark, accent),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("ABORT", style: TextStyle(color: isDark ? Colors.white38 : Colors.black38))),
          TextButton(
              onPressed: _addClassManually,
              child: Text("CONFIRM", style: TextStyle(color: accent, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(TextEditingController ctrl, String hint, bool isDark, Color accent) {
    return TextField(
      controller: ctrl,
      style: TextStyle(color: accent, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}