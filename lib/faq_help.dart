import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class HelpFAQScreen extends StatefulWidget {
  const HelpFAQScreen({super.key});

  @override
  State<HelpFAQScreen> createState() => _HelpFAQScreenState();
}

class _HelpFAQScreenState extends State<HelpFAQScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & FAQ',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // --- 1. SEARCH BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                ],
              ),
              child: TextField(
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  icon: const Icon(Icons.search_rounded, color: Colors.blueAccent),
                  hintText: 'Search for help...',
                  hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // --- 2. FAQ CATEGORIES ---
            _buildSectionTitle('General', isDark),
            _buildFAQTile(
              'What is FocusFlow?',
              'FocusFlow is an all-in-one productivity hub designed specifically for students to manage tasks, schedules, and study sessions.',
              isDark,
            ),
            _buildFAQTile(
              'Is my data synced across devices?',
              'Currently, data is stored locally. Cloud sync via Firebase is coming in the next update!',
              isDark,
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Focus Timer', isDark),
            _buildFAQTile(
              'What is the Pomodoro technique?',
              'It’s a time management method that uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks.',
              isDark,
            ),
            _buildFAQTile(
              'Can I customize break times?',
              'Yes! You can adjust the work and break durations within the Timer settings.',
              isDark,
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Schedule & Sync', isDark),
            _buildFAQTile(
              'How do I add a new class?',
              'Go to the Schedule tab and tap the "+" icon at the bottom right to manually enter your class details.',
              isDark,
            ),
            _buildFAQTile(
              'How does the Syllabus Upload work?',
              'You can upload a PDF of your syllabus, and our AI will attempt to extract dates and times to populate your schedule automatically.',
              isDark,
            ),

            const SizedBox(height: 40),

            // --- 3. CONTACT SUPPORT CARD ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Still need help?',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our support team is ready to assist you with any issues.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text('Contact Us', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.blueAccent : Colors.blue[900],
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        iconColor: Colors.blueAccent,
        collapsedIconColor: Colors.grey,
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}