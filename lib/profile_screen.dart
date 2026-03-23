import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _syncCalendar = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final accentColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- 2. HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NODE',
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
                        child: Icon(Icons.hub_rounded, color: accentColor, size: 24),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- 3. GLASS USER INFO CARD ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            // Monochrome Profile Picture
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: isDark ? Colors.white24 : Colors.black12, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                                child: Icon(Icons.person, size: 50, color: accentColor),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'ALEX STUDENT',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1, color: accentColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'LVL 12 SCHOLAR • CS BRANCH',
                              style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black54, fontWeight: FontWeight.bold, letterSpacing: 2),
                            ),
                            const SizedBox(height: 24),
                            // Hollow Monochrome Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: accentColor, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text(
                                    'MODIFY CONFIG',
                                    style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 4. BENTO STATS (Monochrome) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox('DIRECTIVES', '142', Icons.task_alt_rounded, isDark, accentColor),
                      const SizedBox(width: 12),
                      _buildStatBox('UPTIME', '14D', Icons.local_fire_department_rounded, isDark, accentColor),
                      const SizedBox(width: 12),
                      _buildStatBox('FOCUS', '56H', Icons.memory_rounded, isDark, accentColor),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- 5. SYSTEM PREFERENCES ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PREFERENCES',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              activeColor: accentColor,
                              title: Text('EXTERNAL SYNC', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor)),
                              subtitle: Text('GOOGLE / APPLE NODES', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
                              secondary: Icon(Icons.sync_rounded, color: accentColor, size: 20),
                              value: _syncCalendar,
                              onChanged: (bool value) => setState(() => _syncCalendar = value),
                            ),
                            Divider(height: 1, indent: 70, endIndent: 20, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                            SwitchListTile(
                              activeColor: accentColor,
                              title: Text('SYSTEM ALERTS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor)),
                              subtitle: Text('PUSH NOTIFICATIONS', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
                              secondary: Icon(Icons.notifications_none_rounded, color: accentColor, size: 20),
                              value: _pushNotifications,
                              onChanged: (bool value) => setState(() => _pushNotifications = value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- 6. TERMINATE SESSION ---
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.power_settings_new_rounded, color: isDark ? Colors.black : Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'TERMINATE SESSION',
                            style: TextStyle(
                                color: isDark ? Colors.black : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildStatBox(String title, String count, IconData icon, bool isDark, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: accent, size: 24),
            const SizedBox(height: 12),
            Text(
              count,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: accent),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 8, color: isDark ? Colors.white38 : Colors.black38, fontWeight: FontWeight.bold, letterSpacing: 1),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}