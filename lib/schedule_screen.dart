import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // 1. THE STATE: Tracking which day is selected (0 = Monday)
  int _selectedDayIndex = 0;
  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  // 2. THE DUMMY DATA: A map of classes for each day
  final Map<int, List<Map<String, String>>> _weeklySchedule = {
    0: [ // Monday
      {'course': 'Introduction to Computer Science', 'time': '09:00 AM - 10:30 AM', 'room': 'Room 402', 'color': 'blue'},
      {'course': 'Calculus I', 'time': '11:00 AM - 12:30 PM', 'room': 'Hall B', 'color': 'orange'},
    ],
    1: [ // Tuesday
      {'course': 'Physics 101', 'time': '10:00 AM - 11:30 AM', 'room': 'Lab 3', 'color': 'green'},
      {'course': 'English Literature', 'time': '01:00 PM - 02:30 PM', 'room': 'Room 205', 'color': 'purple'},
    ],
    2: [ // Wednesday
      {'course': 'Introduction to Computer Science', 'time': '09:00 AM - 10:30 AM', 'room': 'Room 402', 'color': 'blue'},
      {'course': 'Calculus I', 'time': '11:00 AM - 12:30 PM', 'room': 'Hall B', 'color': 'orange'},
      {'course': 'Study Group', 'time': '03:00 PM - 04:30 PM', 'room': 'Library', 'color': 'grey'},
    ],
    3: [ // Thursday
      {'course': 'Physics 101', 'time': '10:00 AM - 11:30 AM', 'room': 'Lab 3', 'color': 'green'},
    ],
    4: [ // Friday
      {'course': 'English Literature', 'time': '01:00 PM - 02:30 PM', 'room': 'Room 205', 'color': 'purple'},
      {'course': 'Free Period / Lab Work', 'time': '03:00 PM - 05:00 PM', 'room': 'MakerSpace', 'color': 'grey'},
    ],
  };

  // A helper function to turn string colors into actual Flutter colors
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
    // Get the classes for the currently selected day (or an empty list if none)
    final dailyClasses = _weeklySchedule[_selectedDayIndex] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // THE DAY PICKER (Mon - Fri)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_daysOfWeek.length, (index) {
                bool isSelected = _selectedDayIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _daysOfWeek[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // THE CLASS LIST
          Expanded(
            child: dailyClasses.isEmpty
                ? const Center(child: Text('No classes today! 🎉', style: TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dailyClasses.length,
              itemBuilder: (context, index) {
                final course = dailyClasses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: _getColor(course['color']!),
                          width: 8, // The colored stripe on the left!
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        course['course']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(course['time']!, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(course['room']!, style: const TextStyle(color: Colors.grey)),
                            ],
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

      // THE "AI UPLOAD" FLOATING BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Future AI PDF Parsing logic goes here!
        },
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.document_scanner),
        label: const Text('Upload Syllabus'),
      ),
    );
  }
}