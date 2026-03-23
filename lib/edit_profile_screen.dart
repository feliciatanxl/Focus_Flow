import 'dart:ui';
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
    // Pre-filling with current data
    _nameController = TextEditingController(text: 'Alex Student');
    _majorController = TextEditingController(text: 'Level 12 Scholar | CS Branch');
    _bioController = TextEditingController(text: 'Compiling success. Aiming for 100% execution this semester. 🚀');
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
    final primaryColor = isDark ? const Color(0xFF00E5FF) : Colors.blueAccent;

    return Scaffold(
      extendBodyBehindAppBar: true, // Let the gradient flow behind the AppBar
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: isDark ? Colors.white : Colors.black87, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Node Configuration', // Tech rename
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          // COMMIT BUTTON
          TextButton(
            onPressed: () {
              // Show futuristic SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Configuration committed successfully.', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                  backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.black87,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isDark ? BorderSide(color: primaryColor, width: 1.5) : BorderSide.none,
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: Text(
              '[ Commit ]',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // --- 2. NEON PROFILE PICTURE EDIT ---
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryColor.withOpacity(0.5), width: 3),
                            boxShadow: isDark ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 20)] : [],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: isDark ? const Color(0xFF1E1E1E) : primaryColor,
                            child: Icon(Icons.person, size: 60, color: isDark ? primaryColor : Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Image Picker logic
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E1E1E) : primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: isDark ? primaryColor : Colors.white, width: 2),
                                boxShadow: isDark ? [BoxShadow(color: primaryColor.withOpacity(0.5), blurRadius: 8)] : [],
                              ),
                              child: Icon(Icons.camera_alt_rounded, color: isDark ? primaryColor : Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- 3. GLASSMORPHIC INPUT BENTO CARD ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('System Alias', isDark),
                            _buildField(_nameController, 'e.g. Alex Student', Icons.badge_rounded, isDark, primaryColor),

                            const SizedBox(height: 20),

                            _buildLabel('Primary Branch', isDark),
                            _buildField(_majorController, 'e.g. Computer Science', Icons.account_tree_rounded, isDark, primaryColor),

                            const SizedBox(height: 20),

                            _buildLabel('Runtime Directives (Bio)', isDark),
                            _buildField(
                                _bioController,
                                'Enter your goals...',
                                Icons.terminal_rounded,
                                isDark,
                                primaryColor,
                                maxLines: 3
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 4. DANGER ZONE ---
                  TextButton(
                    onPressed: () {
                      // Logic to delete account
                    },
                    child: Text(
                      'Purge Node Data', // Tech rename
                      style: TextStyle(
                          color: isDark ? Colors.redAccent : Colors.red[700],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER: TEXT LABELS ---
  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
        ),
      ),
    );
  }

  // --- HELPER: MODERN GLASS TEXT FIELDS ---
  Widget _buildField(TextEditingController controller, String hint, IconData icon, bool isDark, Color primaryColor, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 45 : 0),
          child: Icon(icon, color: isDark ? primaryColor : Colors.blueAccent),
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        // Glow effect when the user clicks the text field
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: isDark ? primaryColor.withOpacity(0.5) : Colors.black,
              width: 1.5
          ),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}