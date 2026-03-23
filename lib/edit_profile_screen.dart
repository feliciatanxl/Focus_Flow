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
  late TextEditingController _nameController;
  late TextEditingController _majorController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'ALEX STUDENT');
    _majorController = TextEditingController(text: 'LVL 12 SCHOLAR • CS BRANCH');
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
    final accentColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: accentColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'NODE CONFIGURATION',
          style: TextStyle(
            color: accentColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          // COMMIT BUTTON
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('CONFIGURATION COMMITTED',
                        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 10)),
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
                Navigator.pop(context);
              },
              child: Text(
                'COMMIT',
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // --- 2. PROFILE PICTURE EDIT ---
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isDark ? Colors.white24 : Colors.black12, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                            child: Icon(Icons.person, size: 60, color: accentColor),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: isDark ? Colors.black : Colors.white, width: 2),
                              ),
                              child: Icon(Icons.camera_alt_rounded,
                                  color: isDark ? Colors.black : Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // --- 3. GLASSMORPHIC INPUT CARD ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                              width: 1.5
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('SYSTEM ALIAS', isDark, accentColor),
                            _buildField(_nameController, 'ALIAS', isDark, accentColor),

                            const SizedBox(height: 24),

                            _buildLabel('PRIMARY BRANCH', isDark, accentColor),
                            _buildField(_majorController, 'BRANCH', isDark, accentColor),

                            const SizedBox(height: 24),

                            _buildLabel('RUNTIME DIRECTIVES', isDark, accentColor),
                            _buildField(
                                _bioController,
                                'BIO_DATA',
                                isDark,
                                accentColor,
                                maxLines: 4
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- 4. DANGER ZONE ---
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'PURGE NODE DATA',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 2
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

  // --- HELPERS ---
  Widget _buildLabel(String text, bool isDark, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, bool isDark, Color accent, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: accent, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26, width: 1),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}