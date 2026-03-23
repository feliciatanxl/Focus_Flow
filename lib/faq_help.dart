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
    final accentColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: accentColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'KNOWLEDGE_BASE',
          style: TextStyle(
            color: accentColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // --- 2. MONOCHROME SEARCH BAR ---
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    ),
                    child: TextField(
                      style: TextStyle(color: accentColor, fontSize: 14),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded, color: accentColor, size: 20),
                        hintText: 'QUERY_DATABASE...',
                        hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 12, letterSpacing: 1),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- 3. FAQ SECTIONS ---
                  _buildSectionTitle('CORE_OPERATIONS', isDark, accentColor),
                  _buildFAQTile(
                    'What is FocusFlow?',
                    'FocusFlow is a high-performance productivity matrix designed for academic optimization and schedule management.',
                    isDark,
                    accentColor,
                  ),
                  _buildFAQTile(
                    'Is data synced?',
                    'Current version operates on local storage protocols. Cloud synchronization is scheduled for the next system update.',
                    isDark,
                    accentColor,
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle('EXECUTION_MODULES', isDark, accentColor),
                  _buildFAQTile(
                    'Pomodoro Technique?',
                    'A time-boxing methodology using 25-minute focus intervals separated by short-duration recovery cycles.',
                    isDark,
                    accentColor,
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle('TIMELINE_SYNC', isDark, accentColor),
                  _buildFAQTile(
                    'Adding new nodes?',
                    'Navigate to the MATRIX tab and initialize the [+] node to manually input schedule data.',
                    isDark,
                    accentColor,
                  ),
                  _buildFAQTile(
                    'Syllabus AI Upload?',
                    'Upload a PDF manifest; the AI parser will extract timestamps and module names to populate your timeline.',
                    isDark,
                    accentColor,
                  ),

                  const SizedBox(height: 40),

                  // --- 4. CONTACT SUPPORT CARD (High Contrast) ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'UNRESOLVED_EXCEPTION?',
                          style: TextStyle(
                              color: isDark ? Colors.black : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Engineering support is available for manual system overrides and bug reporting.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isDark ? Colors.black54 : Colors.white54,
                              fontSize: 12,
                              height: 1.4
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.black : Colors.white,
                              foregroundColor: isDark ? Colors.white : Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                                'OPEN_SUPPORT_TICKET',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer, bool isDark, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: accent,
          collapsedIconColor: isDark ? Colors.white24 : Colors.black26,
          title: Text(
            question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 13,
                    height: 1.5
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}