import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'home_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the Brain for Dark Mode!
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true, // Lets the gradient flow behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                      : [Colors.white, const Color(0xFFF0F4F8), Colors.white],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // --- 2. HEADER SECTION (Cyber Vibe) ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF00E5FF).withOpacity(0.1) : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isDark ? [
                        BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.2), blurRadius: 20)
                      ] : [],
                    ),
                    child: Icon(
                        Icons.person_add_rounded,
                        size: 40,
                        color: isDark ? const Color(0xFF00E5FF) : Colors.black
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Initialize Profile',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Register your node to join the FocusFlow network.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- 3. GLASSMORPHIC INPUT PANEL ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildTextField(
                              hint: 'Full Name',
                              icon: Icons.badge_rounded,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              hint: 'Email Address',
                              icon: Icons.alternate_email_rounded,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              hint: 'Password',
                              icon: Icons.password_rounded,
                              isDark: isDark,
                              isPassword: true,
                            ),
                            const SizedBox(height: 30),

                            // --- NEON SIGN UP BUTTON ---
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark ? Colors.transparent : Colors.black,
                                  foregroundColor: isDark ? const Color(0xFF00E5FF) : Colors.white,
                                  shadowColor: isDark ? const Color(0xFF00E5FF).withOpacity(0.5) : Colors.black26,
                                  elevation: isDark ? 10 : 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: isDark ? const BorderSide(color: Color(0xFF00E5FF), width: 1.5) : BorderSide.none,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                                  );
                                },
                                child: const Text(
                                    '[ Initialize ]',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- 4. GLASS SOCIAL LOGIN SECTION ---
                  Center(
                    child: Text(
                      'Or connect via external provider',
                      style: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildSocialTile(
                        icon: Icons.g_mobiledata_rounded,
                        label: 'Google',
                        isDark: isDark,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 16),
                      _buildSocialTile(
                        icon: Icons.apple_rounded,
                        label: 'Apple',
                        isDark: isDark,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- 5. FOOTER ---
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          text: "Already have a token? ",
                          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                          children: [
                            TextSpan(
                              text: 'Authenticate',
                              style: TextStyle(
                                  color: isDark ? const Color(0xFF00E5FF) : Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER: MODERN GLASS TEXT FIELDS ---
  Widget _buildTextField({required String hint, required IconData icon, required bool isDark, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
        prefixIcon: Icon(icon, color: isDark ? const Color(0xFF00E5FF) : Colors.black54),
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
              color: isDark ? const Color(0xFF00E5FF).withOpacity(0.5) : Colors.black,
              width: 1.5
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }

  // --- HELPER: GLASS SOCIAL TILES ---
  Widget _buildSocialTile({required IconData icon, required String label, required bool isDark, required Color color}) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200),
            ),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 30),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}