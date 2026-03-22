import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // 1. THE STATE (Now includes the weekend!)
  int _selectedDayIndex = 0;
  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // 2. THE DUMMY DATA (Added classes/events for index 5 and 6)
  final Map<int, List<Map<String, String>>> _weeklySchedule = {
    0: [ // Mon
      {'course': 'Intro to Computer Science', 'time': '09:00 AM - 10:30 AM', 'room': 'Room 402', 'color': 'blue'},
      {'course': 'Calculus I', 'time': '11:00 AM - 12:30 PM', 'room': 'Hall B', 'color': 'orange'},
    ],
    1: [ // Tue
      {'course': 'Physics 101', 'time': '10:00 AM - 11:30 AM', 'room': 'Lab 3', 'color': 'green'},
      {'course': 'English Literature', 'time': '01:00 PM - 02:30 PM', 'room': 'Room 205', 'color': 'purple'},
    ],
    2: [ // Wed
      {'course': 'Intro to Computer Science', 'time': '09:00 AM - 10:30 AM', 'room': 'Room 402', 'color': 'blue'},
      {'course': 'Calculus I', 'time': '11:00 AM - 12:30 PM', 'room': 'Hall B', 'color': 'orange'},
      {'course': 'Study Group', 'time': '03:00 PM - 04:30 PM', 'room': 'Library', 'color': 'grey'},
    ],
    3: [ // Thu
      {'course': 'Physics 101', 'time': '10:00 AM - 11:30 AM', 'room': 'Lab 3', 'color': 'green'},
    ],
    4: [ // Fri
      {'course': 'English Literature', 'time': '01:00 PM - 02:30 PM', 'room': 'Room 205', 'color': 'purple'},
      {'course': 'Free Period / Lab Work', 'time': '03:00 PM - 05:00 PM', 'room': 'MakerSpace', 'color': 'grey'},
    ],
    5: [ // Sat
      {'course': 'Hackathon Prep', 'time': '10:00 AM - 02:00 PM', 'room': 'Student Center', 'color': 'orange'},
    ],
    6: [ // Sun
      {'course': 'Rest & Recovery', 'time': 'All Day', 'room': 'Everywhere', 'color': 'blue'},
    ],
  };

  // Helper function to turn strings into Flutter Colors
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
            // --- 1. SLEEK OVERSIZED HEADER ---
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
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Icon(Icons.calendar_month_rounded, color: isDark ? Colors.white : Colors.black87),
                  )
                ],
              ),
            ),

            // --- 2. THE DAY PICKER (Now horizontally scrollable!) ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // Gives it that smooth, bouncy feel
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: List.generate(_daysOfWeek.length, (index) {
                  bool isSelected = _selectedDayIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0), // Spacing between pills
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDayIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blueAccent
                              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: isSelected
                              ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]
                              : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Text(
                          _daysOfWeek[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // --- 3. THE CLASS LIST ---
            Expanded(
              child: dailyClasses.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.celebration_rounded, size: 60, color: isDark ? Colors.grey[800] : Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('No classes today! 🎉', style: TextStyle(fontSize: 18, color: isDark ? Colors.grey[500] : Colors.grey)),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                itemCount: dailyClasses.length,
                itemBuilder: (context, index) {
                  final course = dailyClasses[index];
                  final cardColor = _getColor(course['color']!);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 15, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Row(
                        children: [
                          // The colored accent bar on the left
                          Container(width: 8, height: 110, color: cardColor),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['course']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      // Glass tinted icon for Time
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(color: cardColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                        child: Icon(Icons.access_time_rounded, size: 16, color: cardColor),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        course['time']!,
                                        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Glass tinted icon for Room
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(color: cardColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                        child: Icon(Icons.location_on_rounded, size: 16, color: cardColor),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        course['room']!,
                                        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        elevation: 4,
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.document_scanner_rounded),
        label: const Text('Upload Syllabus', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}