import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _notifications = true;

  void _triggerHaptic() {
    if (_hapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final accentColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- UNIFIED HEADER SECTION ---
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'CONFIG',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                            letterSpacing: -1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.settings_suggest_outlined, size: 24, color: accentColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '> Modify local environment variables.',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // --- PREFERENCES ---
              _buildSectionHeader('[ USER_PREFERENCES ]', isDark),
              _buildSettingsGroup(
                isDark: isDark,
                children: [
                  _buildToggleRow(
                    'WEEK_STARTS_ON_MONDAY',
                    Icons.calendar_view_week_rounded,
                    _startWeekOnMonday,
                    isDark,
                    accentColor,
                        (val) {
                      _triggerHaptic();
                      setState(() => _startWeekOnMonday = val);
                    },
                  ),
                  _buildDivider(isDark),
                  _buildToggleRow(
                    'HAPTIC_FEEDBACK',
                    Icons.vibration_rounded,
                    _hapticFeedback,
                    isDark,
                    accentColor,
                        (val) {
                      setState(() => _hapticFeedback = val);
                      if (val) HapticFeedback.mediumImpact();
                    },
                  ),
                  _buildDivider(isDark),
                  _buildToggleRow(
                    'PUSH_NOTIFICATIONS',
                    Icons.notifications_outlined,
                    _notifications,
                    isDark,
                    accentColor,
                        (val) {
                      _triggerHaptic();
                      setState(() => _notifications = val);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- APPEARANCE ---
              _buildSectionHeader('[ UI_APPEARANCE ]', isDark),
              _buildSettingsGroup(
                isDark: isDark,
                children: [
                  _buildThemeRow(context, isDark, accentColor, themeProvider),
                ],
              ),

              const SizedBox(height: 32),

              // --- DATA MANAGEMENT ---
              _buildSectionHeader('[ DATA_MANAGEMENT ]', isDark),
              _buildSettingsGroup(
                isDark: isDark,
                children: [
                  _buildActionRow(
                    'EXPORT_LOCAL_DATA',
                    Icons.upload_file_outlined,
                    isDark,
                    accentColor,
                        () {
                      _triggerHaptic();
                      _showNotification(context, 'SYSTEM: Export protocol initiated.', isDark);
                    },
                  ),
                  _buildDivider(isDark),
                  _buildActionRow(
                    'PURGE_SYSTEM_CACHE',
                    Icons.delete_outline_rounded,
                    isDark,
                    accentColor,
                        () {
                      _triggerHaptic();
                      _showConfirmDialog(context, isDark, accentColor);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- SYSTEM ---
              _buildSectionHeader('[ CORE_SYSTEM ]', isDark),
              _buildSettingsGroup(
                isDark: isDark,
                children: [
                  _buildNavRow(
                    'HELP_AND_FAQ',
                    Icons.help_outline_rounded,
                    isDark,
                    accentColor,
                        () {
                      _triggerHaptic();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpFAQScreen()));
                    },
                  ),
                  _buildDivider(isDark),
                  _buildInfoRow(
                    'CORE_VERSION',
                    Icons.terminal_rounded,
                    'v2.4.1_STABLE',
                    isDark,
                    accentColor,
                  ),
                  _buildDivider(isDark),
                  _buildNavRow(
                    'SECURITY_POLICY',
                    Icons.shield_outlined,
                    isDark,
                    accentColor,
                        () {
                      _triggerHaptic();
                      _showNotification(context, 'SYSTEM: Loading security protocols...', isDark);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== SECTION HEADER ====================
  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 12),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }

  // ==================== SETTINGS GROUP (Monochrome Border) ====================
  Widget _buildSettingsGroup({required bool isDark, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          width: 1.5,
        ),
      ),
      child: Column(children: children),
    );
  }

  // ==================== DIVIDER ====================
  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
      ),
    );
  }

  // ==================== THEME ROW ====================
  Widget _buildThemeRow(BuildContext context, bool isDark, Color accentColor, ThemeProvider provider) {
    return InkWell(
      onTap: () {
        _triggerHaptic();
        provider.toggleTheme(!isDark);
      },
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            _buildMonochromeIcon(isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined, isDark, accentColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THEME_MODE',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isDark ? 'OBSIDIAN (DARK)' : 'FROST (LIGHT)',
                    style: TextStyle(fontSize: 11, fontFamily: 'Courier', color: isDark ? Colors.white54 : Colors.black54),
                  ),
                ],
              ),
            ),
            _buildSwitch(isDark, accentColor, isDark),
          ],
        ),
      ),
    );
  }

  // ==================== TOGGLE ROW ====================
  Widget _buildToggleRow(String title, IconData icon, bool value, bool isDark, Color accentColor, ValueChanged<bool> onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            _buildMonochromeIcon(icon, isDark, accentColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 0.5),
              ),
            ),
            _buildSwitch(value, accentColor, isDark),
          ],
        ),
      ),
    );
  }

  // ==================== ACTION ROW ====================
  Widget _buildActionRow(String title, IconData icon, bool isDark, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            _buildMonochromeIcon(icon, isDark, color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.5),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white30 : Colors.black26),
          ],
        ),
      ),
    );
  }

  // ==================== NAV ROW ====================
  Widget _buildNavRow(String title, IconData icon, bool isDark, Color accentColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            _buildMonochromeIcon(icon, isDark, accentColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 0.5),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white30 : Colors.black26),
          ],
        ),
      ),
    );
  }

  // ==================== INFO ROW ====================
  Widget _buildInfoRow(String title, IconData icon, String trailing, bool isDark, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildMonochromeIcon(icon, isDark, accentColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 0.5),
            ),
          ),
          Text(
            trailing,
            style: TextStyle(fontSize: 12, fontFamily: 'Courier', fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.black38),
          ),
        ],
      ),
    );
  }

  // ==================== MONOCHROME ICON CONTAINER ====================
  Widget _buildMonochromeIcon(IconData icon, bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
      ),
      child: Icon(icon, size: 18, color: accentColor),
    );
  }

  // ==================== CUSTOM SWITCH ====================
  Widget _buildSwitch(bool value, Color accentColor, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: value ? accentColor : (isDark ? Colors.white24 : Colors.black26), width: 1.5),
        color: value ? accentColor : Colors.transparent,
      ),
      padding: const EdgeInsets.all(2),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white54 : Colors.black54),
          ),
        ),
      ),
    );
  }

  // ==================== TERMINAL NOTIFICATION ====================
  void _showNotification(BuildContext context, String msg, bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(fontFamily: 'Courier', fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.black : Colors.white),
        ),
        backgroundColor: isDark ? Colors.white : Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ==================== TERMINAL CONFIRM DIALOG ====================
  void _showConfirmDialog(BuildContext context, bool isDark, Color accentColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
        ),
        title: Text(
          'WARNING: PURGE CACHE?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: accentColor, letterSpacing: 0.5),
        ),
        content: Text(
          'This action will permanently delete all cached temporary data from the local environment. Do you wish to proceed?',
          style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('< CANCEL >', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: isDark ? Colors.black : Colors.white,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showNotification(context, 'SYSTEM: Cache purged successfully.', isDark);
            },
            child: const Text('EXECUTE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }
}