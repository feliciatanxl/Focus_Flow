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

  // Stores events linked to specific dates
  final Map<DateTime, List<Map<String, String>>> _events = {};

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final accentColor = isDark ? Colors.white : Colors.black;

    final selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
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
                        'Timeline',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                          color: accentColor,
                        ),
                      ),
                      Icon(Icons.blur_on_rounded, color: accentColor, size: 28),
                    ],
                  ),
                ),

                // --- 3. THE OBSIDIAN CALENDAR CARD ---
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                              width: 1.5
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                            eventLoader: _getEventsForDay,
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            // --- CALENDAR STYLING ---
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: TextStyle(color: accentColor),
                              weekendTextStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                              outsideTextStyle: TextStyle(color: isDark ? Colors.white12 : Colors.black12),

                              // Event Markers (Dots)
                              markerDecoration: BoxDecoration(
                                  color: isDark ? Colors.white54 : Colors.black54,
                                  shape: BoxShape.circle
                              ),

                              // Selected Day
                              selectedDecoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: TextStyle(
                                  color: isDark ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold
                              ),

                              // Today
                              todayDecoration: BoxDecoration(
                                border: Border.all(color: accentColor, width: 1),
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1
                              ),
                              leftChevronIcon: Icon(Icons.chevron_left_rounded, color: accentColor),
                              rightChevronIcon: Icon(Icons.chevron_right_rounded, color: accentColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // --- 4. LIST HEADER WITH ADD ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Directives',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: accentColor
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showAddEventDialog(isDark, accentColor),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                  Icons.add_rounded,
                                  size: 16,
                                  color: isDark ? Colors.black : Colors.white
                              ),
                              const SizedBox(width: 4),
                              Text(
                                  'ADD',
                                  style: TextStyle(
                                      color: isDark ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      letterSpacing: 1
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 5. EVENT LIST ---
                Expanded(
                  child: selectedEvents.isEmpty
                      ? _buildEmptyState(isDark, accentColor)
                      : ListView.builder(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = selectedEvents[index];
                      return GestureDetector(
                        onLongPress: () => _confirmDelete(index, isDark, accentColor),
                        child: _buildEventCard(event['title']!, event['time']!, isDark, accentColor),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---
  Widget _buildEmptyState(bool isDark, Color accent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.blur_off_rounded, size: 60, color: isDark ? Colors.white12 : Colors.black12),
          const SizedBox(height: 10),
          Text(
              'NO DATA DETECTED',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: isDark ? Colors.white24 : Colors.black26
              )
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, String time, bool isDark, Color accent) {
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
                Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10))
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: accent
                          )
                      ),
                      Text(
                          time,
                          style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- DIALOGS ---
  void _showAddEventDialog(bool isDark, Color accent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: isDark ? Colors.white10 : Colors.transparent)
        ),
        title: Text(
            'INITIALIZE EVENT',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: accent)
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(_titleController, 'EVENT NAME', isDark, accent),
              const SizedBox(height: 12),
              _buildDialogField(_timeController, 'TIMESTAMP', isDark, accent),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ABORT', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38))
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                setState(() {
                  final day = _normalizeDate(_selectedDay!);
                  _events.putIfAbsent(day, () => []).add({
                    'title': _titleController.text,
                    'time': _timeController.text.isEmpty ? 'ALL DAY' : _timeController.text
                  });
                });
                _titleController.clear(); _timeController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('CONFIRM', style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  void _confirmDelete(int index, bool isDark, Color accent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        title: Text('PURGE DIRECTIVE?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accent)),
        content: const Text('This action will erase this node from the timeline.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ABORT', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38))),
          TextButton(
            onPressed: () {
              setState(() => _events[_normalizeDate(_selectedDay!)]!.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('PURGE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}