import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for our toggles
  bool _isDarkMode = false;
  bool _startWeekOnMonday = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- SECTION 1: APPEARANCE ---
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('Appearance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.blueAccent,
                  title: const Text('Dark Mode'),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  value: _isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    // Note: Actually changing the whole app's theme requires a State Manager like Provider!
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- SECTION 2: GENERAL ---
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('General', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.blueAccent,
                  title: const Text('Start week on Monday'),
                  secondary: const Icon(Icons.calendar_view_week),
                  value: _startWeekOnMonday,
                  onChanged: (bool value) {
                    setState(() {
                      _startWeekOnMonday = value;
                    });
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  trailing: const Text('English', style: TextStyle(color: Colors.grey)),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- SECTION 3: DATA & PRIVACY ---
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('Data & Privacy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Export My Data'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preparing data export...')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Clear App Cache', style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cache cleared!')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- SECTION 4: ABOUT ---
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('About', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {},
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('App Version'),
                  trailing: Text('v1.0.0', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}