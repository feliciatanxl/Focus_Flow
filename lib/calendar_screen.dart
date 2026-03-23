import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

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
    final primaryColor = isDark ? const Color(0xFF00E5FF) : Colors.blueAccent;

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
                // --- 2. SLEEK OVERSIZED HEADER ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Global Timeline', // Tech rename
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
                          boxShadow: isDark ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 10)] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Icon(Icons.date_range_rounded, color: isDark ? primaryColor : Colors.black87),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // --- 3. THE FLOATING GLASS CALENDAR CARD ---
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.05), blurRadius: 20, offset: const Offset(0, 10)),
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

                            // --- CYBER CALENDAR STYLING ---
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[800], fontWeight: FontWeight.bold),
                              weekendStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[600], fontWeight: FontWeight.bold),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                              leftChevronIcon: Icon(Icons.chevron_left_rounded, color: isDark ? primaryColor : Colors.black87),
                              rightChevronIcon: Icon(Icons.chevron_right_rounded, color: isDark ? primaryColor : Colors.black87),
                            ),
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
                              weekendTextStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w500),
                              outsideTextStyle: TextStyle(color: isDark ? Colors.grey[800] : Colors.grey[400]),

                              // The Neon Glowing Circle for the Selected Day
                              selectedDecoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: isDark ? [BoxShadow(color: primaryColor.withOpacity(0.6), blurRadius: 10, spreadRadius: 1)] : [],
                              ),
                              // A lighter circle for "Today" if it's not selected
                              todayDecoration: BoxDecoration(
                                color: isDark ? primaryColor.withOpacity(0.2) : Colors.blue[100],
                                shape: BoxShape.circle,
                                border: isDark ? Border.all(color: primaryColor.withOpacity(0.5)) : null,
                              ),
                              todayTextStyle: TextStyle(
                                  color: isDark ? primaryColor : Colors.blueAccent,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- 4. EVENT LIST HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Daily Directives', // Tech rename
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // --- 5. GLASS EMPTY STATE ---
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0).copyWith(bottom: 100.0), // Padding for FAB
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.02) : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200, width: 1.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black26 : Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.event_busy_rounded, size: 40, color: isDark ? Colors.grey[700] : Colors.grey[400]),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'NO EVENTS DETECTED',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + node to initialize an event',
                                style: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // --- 6. NEON FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : primaryColor,
        foregroundColor: isDark ? primaryColor : Colors.white,
        elevation: isDark ? 10 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark ? BorderSide(color: primaryColor, width: 1.5) : BorderSide.none,
        ),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}