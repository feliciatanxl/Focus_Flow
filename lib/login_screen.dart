import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // REQUIRED for Google Auth call
import 'theme_provider.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'auth_service.dart'; // IMPORTANT: Brings in the database engine

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controllers to read what the user types
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Loading State & Auth Service
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. The Execution Function (Talks to Supabase for Email/Password)
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SYSTEM_ERROR: Credentials required.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("Authenticating with Supabase...");

      // Sending data to Supabase to verify
      await _authService.signIn(
        email: email,
        password: password,
      );

      print("SUCCESS: Access Granted!");

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
          const SnackBar(content: Text('AUTH_FAILURE: Invalid credentials.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 4. NEW: Google OAuth Execution Function
  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _isLoading = true);

      // Triggers the browser-based OAuth flow
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://callback', // Must match your Supabase & Google settings
      );

      print("Google Sign-In initiated...");
    } catch (e) {
      print("Google Auth Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GOOGLE_AUTH_FAILURE: Could not initiate sign-in.')),
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
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // --- 1. HEADER SECTION ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.fingerprint_rounded, size: 40, color: accentColor),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'SYSTEM_AUTH',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1, color: accentColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Provide credentials to access the workspace.',
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
                          controller: _emailController,
                          hint: 'EMAIL_ADDRESS',
                          icon: Icons.alternate_email_rounded,
                          isDark: isDark,
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _passwordController,
                          hint: 'PASSWORD_HASH',
                          icon: Icons.lock_outline_rounded,
                          isDark: isDark,
                          accentColor: accentColor,
                          isPassword: true,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                                'FORGOT_PASS?',
                                style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // --- SOLID AUTHENTICATE BUTTON ---
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
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(color: isDark ? Colors.black : Colors.white, strokeWidth: 2)
                            )
                                : const Text('AUTHENTICATE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- 3. EXTERNAL PROVIDERS ---
                  Center(
                    child: Text(
                      'EXTERNAL_LINK_REQUIRED?',
                      style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      // UPDATED: Connected the Google Tap Handler
                      _buildSocialTile(
                        icon: Icons.g_mobiledata_rounded,
                        label: 'GOOGLE',
                        isDark: isDark,
                        accentColor: accentColor,
                        onTap: _handleGoogleSignIn,
                      )
                    ],
                  ),

                  const SizedBox(height: 50),

                  // --- 4. FOOTER ---
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "NO_ACCESS_TOKEN? ",
                          style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 11, letterSpacing: 1),
                          children: [
                            TextSpan(text: 'INITIALIZE_ACCOUNT', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Required TextEditingController added here
  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, required bool isDark, required Color accentColor, bool isPassword = false}) {
    return TextField(
      controller: controller,
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

  // UPDATED: Now accepts an optional VoidCallback parameter for onTap
  Widget _buildSocialTile({
    required IconData icon,
    required String label,
    required bool isDark,
    required Color accentColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
          color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        ),
        child: InkWell(
          onTap: onTap, // Connected the callback here
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