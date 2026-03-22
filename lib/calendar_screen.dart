import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart'; // To listen to Dark Mode!
import 'theme_provider.dart';            // Your app's brain

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // Start by selecting today
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the Brain for Dark Mode!
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      // Dynamic Background Color
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
                    'My Calendar',
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
                    child: Icon(Icons.date_range_rounded, color: isDark ? Colors.white : Colors.black87),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),

            // --- 2. THE FLOATING CALENDAR CARD ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },

                  // --- DARK MODE CALENDAR STYLING ---
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[800], fontWeight: FontWeight.bold),
                    weekendStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                    leftChevronIcon: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white : Colors.black87),
                    rightChevronIcon: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white : Colors.black87),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
                    weekendTextStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w500),
                    outsideTextStyle: TextStyle(color: isDark ? Colors.grey[700] : Colors.grey[400]),

                    // The blue circle for the selected day
                    selectedDecoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    // A lighter blue/grey circle for "Today" if it's not selected
                    todayDecoration: BoxDecoration(
                      color: isDark ? Colors.blueAccent.withOpacity(0.3) : Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                        color: isDark ? Colors.blue[200] : Colors.blueAccent,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- 3. EVENT LIST HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Schedule for the day',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 4. PREMIUM EMPTY STATE ---
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0).copyWith(bottom: 24.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.event_available_rounded, size: 40, color: isDark ? Colors.grey[400] : Colors.grey[400]),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No events scheduled.',
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add a new event',
                      style: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // FLOATING ACTION BUTTON (To add events later!)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}