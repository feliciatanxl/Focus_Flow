import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'home_screen.dart';
import 'auth_service.dart'; // IMPORTANT: This links your database!

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 1. Controllers to read what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Loading State & Auth Service
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. The Execution Function (Talks to Supabase)
  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print("--- INITIATING SIGN UP SEQUENCE ---");

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SYSTEM_ERROR: All fields required.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("Attempting to reach Supabase...");

      // Sending data to Supabase
      await _authService.signUp(
        email: email,
        password: password,
        fullName: name,
      );

      print("SUCCESS: User created!");

      // If successful, route to the Hub!
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print("SUPABASE ERROR CAUGHT: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AUTH_FAILURE: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: accentColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // --- 1. HEADER SECTION ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.person_add_rounded, size: 40, color: accentColor),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PROFILE_SETUP',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1, color: accentColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Register your node to join the Matrix.',
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.white38 : Colors.black38, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 40),

                  // --- 2. MONOCHROME INPUT PANEL ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController, // LINKED!
                          hint: 'FULL_NAME',
                          icon: Icons.badge_outlined,
                          isDark: isDark,
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController, // LINKED!
                          hint: 'EMAIL_ADDRESS',
                          icon: Icons.alternate_email_rounded,
                          isDark: isDark,
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _passwordController, // LINKED!
                          hint: 'ACCESS_KEY_HASH',
                          icon: Icons.lock_outline_rounded,
                          isDark: isDark,
                          accentColor: accentColor,
                          isPassword: true,
                        ),
                        const SizedBox(height: 30),

                        // --- SOLID INITIALIZE BUTTON (Now with loading state) ---
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _isLoading ? null : _handleSignUp, // TRIGGERS DATABASE!
                            child: _isLoading
                                ? SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(color: isDark ? Colors.black : Colors.white, strokeWidth: 2)
                            )
                                : const Text('INITIALIZE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- 3. EXTERNAL LINK SECTION ---
                  Center(
                    child: Text(
                      'EXTERNAL_PROVIDER_LINK',
                      style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildSocialTile(icon: Icons.g_mobiledata_rounded, label: 'GOOGLE', isDark: isDark, accentColor: accentColor),
                      const SizedBox(width: 16),
                      _buildSocialTile(icon: Icons.apple_rounded, label: 'APPLE', isDark: isDark, accentColor: accentColor),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- 4. FOOTER ---
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          text: "TOKEN_ALREADY_EXISTS? ",
                          style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 11, letterSpacing: 1),
                          children: [
                            TextSpan(text: 'AUTHENTICATE', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
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

  // Notice we added 'required TextEditingController controller' here
  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, required bool isDark, required Color accentColor, bool isPassword = false}) {
    return TextField(
      controller: controller, // And linked it here!
      obscureText: isPassword,
      style: TextStyle(color: accentColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 12, letterSpacing: 1),
        prefixIcon: Icon(icon, color: isDark ? Colors.white38 : Colors.black38, size: 20),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26, width: 1)),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  Widget _buildSocialTile({required IconData icon, required String label, required bool isDark, required Color accentColor}) {
    return Expanded(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
          color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: accentColor, size: 24),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1, color: accentColor)),
            ],
          ),
        ),
      ),
    );
  }
}