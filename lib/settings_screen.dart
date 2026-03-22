import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // We removed _isDarkMode from here because the Provider handles it now!
  bool _startWeekOnMonday = true;
  bool _hapticFeedback = true;

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the Brain!
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode; // True if dark mode is on

    return Scaffold(
      // 2. Remove the hardcoded background color so it uses the global theme!
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. Dynamic Text Color
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  color: isDark ? Colors.white : Colors.black87, // Flips color!
                ),
              ),
              const SizedBox(height: 30),

              // Top Row: Full-width Dark Mode toggle
              _buildWideBentoToggle(
                title: 'Dark Mode',
                subtitle: 'Switch to a darker theme',
                icon: Icons.dark_mode_rounded,
                isActive: isDark,
                isAppDark: isDark,
                onTap: () {
                  final provider = Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(!provider.isDarkMode);
                },
              ),
              const SizedBox(height: 16),

              // Middle Row: Two square blocks side-by-side
              Row(
                children: [
                  Expanded(
                    child: _buildSquareBentoToggle(
                      title: 'Start Week\non Mon',
                      icon: Icons.calendar_view_week_rounded,
                      isActive: _startWeekOnMonday,
                      isAppDark: isDark,
                      onTap: () => setState(() => _startWeekOnMonday = !_startWeekOnMonday),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSquareBentoToggle(
                      title: 'Haptic\nFeedback',
                      icon: Icons.vibration_rounded,
                      isActive: _hapticFeedback,
                      isAppDark: isDark,
                      onTap: () => setState(() => _hapticFeedback = !_hapticFeedback),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bottom Row: Actions
              Row(
                children: [
                  Expanded(
                    child: _buildSquareBentoAction(
                      title: 'Export\nData',
                      icon: Icons.cloud_download_rounded,
                      color: Colors.blueAccent,
                      isAppDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Preparing data export...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSquareBentoAction(
                      title: 'Clear\nCache',
                      icon: Icons.delete_sweep_rounded,
                      color: Colors.redAccent,
                      isAppDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cache cleared successfully!')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // ABOUT & SUPPORT
              Text(
                'Support',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87, // Flips color!
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white, // Dark box in dark mode
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: isDark ? Colors.blueAccent.withOpacity(0.2) : Colors.blue[50],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Icon(Icons.help_center_rounded, color: Colors.blueAccent),
                      ),
                      title: Text('Help & FAQ', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Icon(Icons.info_rounded, color: Colors.grey),
                      ),
                      title: Text('App Version', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                      trailing: const Text('v1.0.0', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET UPDATES (Notice the new 'isAppDark' variable passed in!) ---

  Widget _buildWideBentoToggle({required String title, required String subtitle, required IconData icon, required bool isActive, required bool isAppDark, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // If active it's blue, otherwise check if app is dark
          color: isActive ? Colors.blueAccent : (isAppDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: isActive ? Colors.white : Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isActive ? Colors.white : (isAppDark ? Colors.white : Colors.black87)),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: isActive ? Colors.white70 : Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.grey[400],
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
                        color: isActive ? Colors.blueAccent : Colors.white
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSquareBentoToggle({required String title, required IconData icon, required bool isActive, required bool isAppDark, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        height: 140,
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent : (isAppDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: isActive ? Colors.white : Colors.blueAccent),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: isActive ? Colors.white : (isAppDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareBentoAction({required String title, required IconData icon, required Color color, required bool isAppDark, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 140,
        decoration: BoxDecoration(
          color: isAppDark ? color.withOpacity(0.05) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withOpacity(isAppDark ? 0.2 : 0.3), width: 1.5),
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
    );
  }
}