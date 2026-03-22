import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // 1. Controllers to handle user input
  late TextEditingController _nameController;
  late TextEditingController _majorController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    // Pre-filling with current data (later this will come from Firebase)
    _nameController = TextEditingController(text: 'Alex Student');
    _majorController = TextEditingController(text: 'Computer Science Major');
    _bioController = TextEditingController(text: 'Aiming for a 4.0 GPA this semester! 🚀');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded,
              color: isDark ? Colors.white : Colors.black87, size: 28),
          onPressed: () => Navigator.pop(context), // "X" to cancel
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // SAVE BUTTON IN APP BAR
          TextButton(
            onPressed: () {
              // Logic to save data goes here!
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile Updated!')),
              );
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- 1. PROFILE PICTURE EDIT ---
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Image Picker logic would go here
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- 2. THE INPUT BENTO CARD ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Full Name', isDark),
                  _buildField(_nameController, 'e.g. Alex Student', Icons.person_outline_rounded, isDark),

                  const SizedBox(height: 20),

                  _buildLabel('Major / Subject', isDark),
                  _buildField(_majorController, 'e.g. Computer Science', Icons.school_outlined, isDark),

                  const SizedBox(height: 20),

                  _buildLabel('Personal Bio', isDark),
                  _buildField(
                      _bioController,
                      'Tell us about your goals...',
                      Icons.edit_note_rounded,
                      isDark,
                      maxLines: 3
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. DANGER ZONE (Optional but looks pro) ---
            TextButton(
              onPressed: () {
                // Logic to delete account
              },
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper to build labels
  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  // Helper to build fields (Consistent with Login/SignUp)
  Widget _buildField(TextEditingController controller, String hint, IconData icon, bool isDark, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 45 : 0), // Aligns icon to top for bio
          child: Icon(icon, color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: isDark ? Colors.black26 : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}