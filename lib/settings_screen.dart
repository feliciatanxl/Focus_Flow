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
    final primaryColor = isDark ? const Color(0xFF00E5FF) : Colors.blueAccent;

    return Scaffold(
      backgroundColor: Colors.transparent, // Let gradient show through
      body: Stack(
        fit: StackFit.expand, // Prevents black void at bottom
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 2. HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'System Config', // Tech rename
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
                        child: Icon(Icons.settings_suggest_rounded, color: isDark ? primaryColor : Colors.black87),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- 3. GLASS BENTO GRID ---
                  _buildWideBentoToggle(
                    title: 'Dark Mode Override',
                    subtitle: 'Initialize cyber aesthetic',
                    icon: Icons.dark_mode_rounded,
                    isActive: isDark,
                    isAppDark: isDark,
                    primaryColor: primaryColor,
                    onTap: () {
                      final provider = Provider.of<ThemeProvider>(context, listen: false);
                      provider.toggleTheme(!provider.isDarkMode);
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSquareBentoToggle(
                          title: 'Initialize\nMon',
                          icon: Icons.view_week_rounded,
                          isActive: _startWeekOnMonday,
                          isAppDark: isDark,
                          primaryColor: primaryColor,
                          onTap: () => setState(() => _startWeekOnMonday = !_startWeekOnMonday),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSquareBentoToggle(
                          title: 'Haptic\nEngine',
                          icon: Icons.vibration_rounded,
                          isActive: _hapticFeedback,
                          isAppDark: isDark,
                          primaryColor: primaryColor,
                          onTap: () => setState(() => _hapticFeedback = !_hapticFeedback),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSquareBentoAction(
                          title: 'Export\nDatabase',
                          icon: Icons.cloud_download_rounded,
                          color: primaryColor,
                          isAppDark: isDark,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Initiating data export...', style: TextStyle(fontWeight: FontWeight.bold)),
                                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.black87,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: isDark ? BorderSide(color: primaryColor, width: 1.5) : BorderSide.none,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSquareBentoAction(
                          title: 'Flush\nMemory',
                          icon: Icons.delete_sweep_rounded,
                          color: isDark ? Colors.redAccent : Colors.red,
                          isAppDark: isDark,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Memory cache purged.', style: TextStyle(fontWeight: FontWeight.bold)),
                                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.black87,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: isDark ? const BorderSide(color: Colors.redAccent, width: 1.5) : BorderSide.none,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- 4. ABOUT & SUPPORT (Glass List) ---
                  Text(
                    'Network Diagnostics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: isDark ? primaryColor.withOpacity(0.15) : Colors.blue[50],
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Icon(Icons.help_center_rounded, color: primaryColor),
                              ),
                              title: Text('Knowledge Base', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.grey[600] : Colors.grey),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpFAQScreen()));
                              },
                            ),
                            Divider(height: 1, indent: 60, endIndent: 20, color: isDark ? Colors.white10 : Colors.grey[200]),
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Icon(Icons.info_rounded, color: isDark ? Colors.grey[400] : Colors.grey),
                              ),
                              title: Text('System Build', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                              trailing: Text('v2.4.1', style: TextStyle(color: isDark ? primaryColor : Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120), // Padding for bottom nav bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER: WIDE GLASS TOGGLE ---
  Widget _buildWideBentoToggle({required String title, required String subtitle, required IconData icon, required bool isActive, required bool isAppDark, required Color primaryColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isActive
                  ? (isAppDark ? primaryColor.withOpacity(0.15) : primaryColor)
                  : (isAppDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                  color: isActive
                      ? primaryColor
                      : (isAppDark ? Colors.white.withOpacity(0.1) : Colors.white),
                  width: isActive && isAppDark ? 1.5 : 1
              ),
              boxShadow: isActive && isAppDark ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 15)] : [],
            ),
            child: Row(
              children: [
                Icon(icon, size: 32, color: isActive ? (isAppDark ? primaryColor : Colors.white) : primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isActive ? (isAppDark ? Colors.white : Colors.white) : (isAppDark ? Colors.white : Colors.black87)),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: isActive ? (isAppDark ? Colors.grey[400] : Colors.white70) : Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isActive ? (isAppDark ? primaryColor : Colors.white) : (isAppDark ? Colors.grey[800] : Colors.grey[400]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? (isAppDark ? Colors.black87 : primaryColor) : Colors.white
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER: SQUARE GLASS TOGGLE ---
  Widget _buildSquareBentoToggle({required String title, required IconData icon, required bool isActive, required bool isAppDark, required Color primaryColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            height: 140,
            decoration: BoxDecoration(
              color: isActive
                  ? (isAppDark ? primaryColor.withOpacity(0.15) : primaryColor)
                  : (isAppDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                  color: isActive
                      ? primaryColor
                      : (isAppDark ? Colors.white.withOpacity(0.1) : Colors.white),
                  width: isActive && isAppDark ? 1.5 : 1
              ),
              boxShadow: isActive && isAppDark ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 15)] : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 32, color: isActive ? (isAppDark ? primaryColor : Colors.white) : primaryColor),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: isActive ? (isAppDark ? Colors.white : Colors.white) : (isAppDark ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER: SQUARE GLASS ACTION ---
  Widget _buildSquareBentoAction({required String title, required IconData icon, required Color color, required bool isAppDark, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 140,
            decoration: BoxDecoration(
              color: isAppDark ? color.withOpacity(0.05) : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: color.withOpacity(isAppDark ? 0.3 : 0.3), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: isAppDark ? Colors.transparent : Colors.white,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.2, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}