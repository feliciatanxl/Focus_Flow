import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'faq_help.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _startWeekOnMonday = true;
  bool _hapticFeedback = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final accentColor = isDark ? Colors.white : Colors.black;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 2. HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CONFIG',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                          color: accentColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.tune_rounded, color: accentColor, size: 24),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- 3. SYSTEM OVERRIDE (WIDE TOGGLE) ---
                  _buildWideToggle(
                    title: 'OBSIDIAN_MODE',
                    subtitle: 'Toggle dark environment',
                    isActive: isDark,
                    isDark: isDark,
                    accentColor: accentColor,
                    onTap: () {
                      final provider = Provider.of<ThemeProvider>(context, listen: false);
                      provider.toggleTheme(!provider.isDarkMode);
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- 4. PREFERENCE BLOCKS (SQUARE) ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildSquareToggle(
                          title: 'WEEK_INIT\nMONDAY',
                          isActive: _startWeekOnMonday,
                          isDark: isDark,
                          accentColor: accentColor,
                          onTap: () => setState(() => _startWeekOnMonday = !_startWeekOnMonday),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSquareToggle(
                          title: 'HAPTIC\nENGINE',
                          isActive: _hapticFeedback,
                          isDark: isDark,
                          accentColor: accentColor,
                          onTap: () => setState(() => _hapticFeedback = !_hapticFeedback),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- 5. MAINTENANCE COMMANDS ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildSquareAction(
                          title: 'EXPORT\nDATA',
                          icon: Icons.download_rounded,
                          isDark: isDark,
                          accentColor: accentColor,
                          onTap: () => _showNotification(context, 'INITIATING_EXPORT', isDark),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSquareAction(
                          title: 'PURGE\nCACHE',
                          icon: Icons.refresh_rounded,
                          isDark: isDark,
                          accentColor: Colors.redAccent,
                          onTap: () => _showNotification(context, 'MEMORY_FLUSHED', isDark),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- 6. DIAGNOSTICS (GLASS LIST) ---
                  Text(
                    'DIAGNOSTICS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        _buildListTile(
                          context,
                          'KNOWLEDGE_BASE',
                          Icons.help_outline_rounded,
                          isDark,
                          accentColor,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpFAQScreen())),
                        ),
                        Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                        _buildListTile(
                          context,
                          'BUILD_VERSION',
                          Icons.info_outline_rounded,
                          isDark,
                          accentColor,
                          trailing: 'v2.4.1',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildWideToggle({required String title, required String subtitle, required bool isActive, required bool isDark, required Color accentColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isActive ? accentColor : (isDark ? Colors.white.withOpacity(0.03) : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: isActive ? (isDark ? Colors.black : Colors.white) : accentColor)),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: isActive ? (isDark ? Colors.black54 : Colors.white54) : (isDark ? Colors.white38 : Colors.black38))),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isActive ? (isDark ? Colors.black26 : Colors.white) : accentColor),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 16, height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? (isDark ? Colors.black : Colors.white) : accentColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSquareToggle({required String title, required bool isActive, required bool isDark, required Color accentColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isActive ? accentColor : (isDark ? Colors.white.withOpacity(0.03) : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 12, height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isActive ? (isDark ? Colors.black : Colors.white) : accentColor, width: 2),
                color: isActive ? (isDark ? Colors.black : Colors.white) : Colors.transparent,
              ),
            ),
            Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: isActive ? (isDark ? Colors.black : Colors.white) : accentColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareAction({required String title, required IconData icon, required bool isDark, required Color accentColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accentColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: accentColor, size: 24),
            Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: accentColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon, bool isDark, Color accent, {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: accent, size: 20),
      title: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: accent)),
      trailing: trailing != null
          ? Text(trailing, style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.black38, fontWeight: FontWeight.bold))
          : Icon(Icons.arrow_forward_ios_rounded, size: 12, color: accent.withOpacity(0.3)),
    );
  }

  void _showNotification(BuildContext context, String msg, bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: isDark ? Colors.white : Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}