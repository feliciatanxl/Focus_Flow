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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- 2. SLEEK HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User Node', // Tech rename
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
                        child: Icon(Icons.hub_rounded, color: isDark ? primaryColor : Colors.black87),
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
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Neon Profile Picture
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor.withOpacity(0.5), width: 3),
                                boxShadow: isDark ? [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20)] : [],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: isDark ? const Color(0xFF1E1E1E) : primaryColor,
                                child: Icon(Icons.person, size: 50, color: isDark ? primaryColor : Colors.white),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Alex Student',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Level 12 Scholar | CS Branch', // Gamified/Tech subtitle
                              style: TextStyle(fontSize: 16, color: isDark ? primaryColor : Colors.grey[600], fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20),
                            // Hollow Neon Edit Button
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark ? Colors.transparent : Colors.blue[50],
                                  foregroundColor: primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: isDark ? BorderSide(color: primaryColor, width: 1.5) : BorderSide.none,
                                  ),
                                ),
                                child: const Text('[ Modify Config ]', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 4. GAMIFICATION STATS (Glass Bento) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox('Directives', '142', Icons.task_alt_rounded, isDark ? const Color(0xFF00E676) : Colors.green, isDark),
                      const SizedBox(width: 12),
                      _buildStatBox('Uptime', '14d', Icons.local_fire_department_rounded, isDark ? const Color(0xFFFF9100) : Colors.orange, isDark),
                      const SizedBox(width: 12),
                      _buildStatBox('Focus (hr)', '56', Icons.memory_rounded, primaryColor, isDark),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- 5. SYSTEM PREFERENCES (Glass List) ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'System Preferences',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87, letterSpacing: 0.5),
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
                            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              activeColor: primaryColor,
                              title: Text('External Sync', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                              subtitle: Text('Google & Apple nodes', style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey)),
                              secondary: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                child: Icon(Icons.sync_rounded, color: primaryColor),
                              ),
                              value: _syncCalendar,
                              onChanged: (bool value) => setState(() => _syncCalendar = value),
                            ),
                            Divider(height: 1, indent: 70, endIndent: 20, color: isDark ? Colors.white10 : Colors.grey[200]),
                            SwitchListTile(
                              activeColor: isDark ? const Color(0xFFD500F9) : Colors.purpleAccent,
                              title: Text('System Alerts', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                              subtitle: Text('Class & deadline overrides', style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey)),
                              secondary: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: (isDark ? const Color(0xFFD500F9) : Colors.purpleAccent).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                child: Icon(Icons.notifications_active_rounded, color: isDark ? const Color(0xFFD500F9) : Colors.purpleAccent),
                              ),
                              value: _pushNotifications,
                              onChanged: (bool value) => setState(() => _pushNotifications = value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- 6. TERMINATE SESSION BUTTON ---
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.redAccent.withOpacity(0.05) : Colors.red[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.redAccent.withOpacity(isDark ? 0.5 : 0.3), width: 1.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.power_settings_new_rounded, color: Colors.redAccent),
                              const SizedBox(width: 8),
                              Text(
                                '[ Terminate Session ]',
                                style: TextStyle(
                                    color: isDark ? Colors.redAccent : Colors.red[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Padding for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- CUSTOM WIDGET: The Glass Bento Stat Boxes ---
  Widget _buildStatBox(String title, String count, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.03), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    boxShadow: isDark ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10)] : [],
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  count,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}