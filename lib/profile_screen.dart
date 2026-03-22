import 'package:flutter/material.dart';
import 'login_screen.dart'; // We need this so the user can log out!

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables for the toggle switches
  bool _syncCalendar = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Hides the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit profile logic later
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. THE HEADER (Picture & Name)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: const Column(
                children: [
                  // The Profile Picture
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blueAccent,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: Colors.blueAccent),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Name and Major
                  Text(
                    'Alex Student',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Computer Science Major',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. THE STATS BOARD (Gamification!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Tasks Done', '142', Icons.task_alt, Colors.green),
                  _buildStatCard('Day Streak', '14', Icons.local_fire_department, Colors.orange),
                  _buildStatCard('Hours Studied', '56', Icons.timer, Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. THE SETTINGS & TOGGLES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text('Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                    child: Column(
                      children: [
                        // The Calendar Sync Toggle (from your portfolio idea!)
                        SwitchListTile(
                          activeColor: Colors.blueAccent,
                          title: const Text('Sync External Calendars'),
                          subtitle: const Text('Google & Apple Calendar'),
                          secondary: const Icon(Icons.sync, color: Colors.blueAccent),
                          value: _syncCalendar,
                          onChanged: (bool value) {
                            setState(() {
                              _syncCalendar = value;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        // Notifications Toggle
                        SwitchListTile(
                          activeColor: Colors.blueAccent,
                          title: const Text('Push Notifications'),
                          subtitle: const Text('Reminders for upcoming classes'),
                          secondary: const Icon(Icons.notifications_active_outlined, color: Colors.blueAccent),
                          value: _pushNotifications,
                          onChanged: (bool value) {
                            setState(() {
                              _pushNotifications = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. THE LOGOUT BUTTON
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      onTap: () {
                        // This routes the user all the way back to the Login Screen!
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper mini-widget to draw those 3 little stat boxes
  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}