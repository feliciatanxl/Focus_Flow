import 'dart:ui';
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
    final primaryColor = isDark ? const Color(0xFF00E5FF) : Colors.blueAccent;

    return Scaffold(
      extendBodyBehindAppBar: true, // Let the gradient flow behind the AppBar
      backgroundColor: Colors.transparent, // Required for gradient stack
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Knowledge Base', // Tech rename
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand, // Prevents black void at the bottom
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // --- 2. GLASSMORPHIC SEARCH BAR ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.05), blurRadius: 10),
                          ],
                        ),
                        child: TextField(
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Icon(Icons.search_rounded, color: isDark ? primaryColor : Colors.blueAccent),
                            ),
                            hintText: 'Query documentation...',
                            hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- 3. FAQ CATEGORIES (Glass Panels) ---
                  _buildSectionTitle('Core Operations', isDark, primaryColor),
                  _buildFAQTile(
                    'What is FocusFlow?',
                    'FocusFlow is an all-in-one productivity hub designed specifically for students to manage tasks, schedules, and study sessions.',
                    isDark,
                    primaryColor,
                  ),
                  _buildFAQTile(
                    'Is my data synced across devices?',
                    'Currently, data is stored locally. Cloud sync via Firebase is coming in the next update!',
                    isDark,
                    primaryColor,
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Execution Modules', isDark, primaryColor),
                  _buildFAQTile(
                    'What is the Pomodoro technique?',
                    'It’s a time management method that uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks.',
                    isDark,
                    primaryColor,
                  ),
                  _buildFAQTile(
                    'Can I customize break times?',
                    'Yes! You can adjust the work and break durations within the Timer settings config.',
                    isDark,
                    primaryColor,
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Timeline Synchronization', isDark, primaryColor),
                  _buildFAQTile(
                    'How do I add a new module?',
                    'Go to the Schedule tab and tap the "+" node at the bottom right to manually enter your class details.',
                    isDark,
                    primaryColor,
                  ),
                  _buildFAQTile(
                    'How does the Syllabus Upload work?',
                    'You can upload a PDF of your syllabus, and our AI will attempt to extract dates and times to populate your schedule automatically.',
                    isDark,
                    primaryColor,
                  ),

                  const SizedBox(height: 40),

                  // --- 4. CONTACT SUPPORT CARD (Neon Glass) ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? primaryColor.withOpacity(0.05) : primaryColor,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                              color: isDark ? primaryColor.withOpacity(0.5) : Colors.transparent,
                              width: 1.5
                          ),
                          boxShadow: isDark ? [
                            BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 20)
                          ] : [
                            BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Unresolved Exception?', // Tech rename
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Our engineering team is ready to assist you with any system issues.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.white70,
                                  fontSize: 14
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark ? Colors.transparent : Colors.white,
                                  foregroundColor: isDark ? primaryColor : primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: isDark ? BorderSide(color: primaryColor, width: 1.5) : BorderSide.none,
                                  ),
                                ),
                                child: const Text(
                                    '[ Open Support Ticket ]',
                                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER: TECH SECTION TITLES ---
  Widget _buildSectionTitle(String title, bool isDark, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: isDark ? primaryColor : Colors.blue[900],
        ),
      ),
    );
  }

  // --- HELPER: GLASS FAQ TILES ---
  Widget _buildFAQTile(String question, String answer, bool isDark, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white, width: 1.5),
            ),
            child: Theme(
              // Removes the weird borders ExpansionTile adds by default
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: primaryColor,
                collapsedIconColor: isDark ? Colors.grey[500] : Colors.grey,
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
            ),
          ),
        ),
      ),
    );
  }
}