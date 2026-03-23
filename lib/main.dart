import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const FocusFlowApp(),
    ),
  );
}

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            // --- NEO-LIGHT THEME ---
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF4F6F9),
              primaryColor: const Color(0xFF00E5FF), // Cyber Cyan
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00E5FF)),
            ),
            // --- FUTURISTIC DARK THEME (The main attraction) ---
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF09090B), // Deep Vercel Black
              primaryColor: const Color(0xFF00E5FF), // Cyber Cyan
              cardColor: const Color(0xFF18181B),
            ),
            home: const SplashScreen(),
          );
        }
    );
  }
}

// -------------------------------------------------------------------------
// 3. THE SPLASH SCREEN (Tech Boot Sequence)
// -------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Keeps your white-BG logo seamless
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/SplashLogo.json',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            // Coding nod: Terminal-style loading text
            const Text(
              'INITIALIZING_WORKSPACE...',
              style: TextStyle(
                fontFamily: 'Courier', // Standard monospace fallback
                color: Colors.grey,
                letterSpacing: 2,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                color: const Color(0xFF00E5FF), // Cyber Cyan
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// 4. THE ONBOARDING TUTORIAL (Futuristic Glassmorphism)
// -------------------------------------------------------------------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Tech Gradient
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
            child: Column(
              children: [
                // Tech-styled Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                      child: Text(
                          '< Skip >',
                          style: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          )
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    children: const [
                      OnboardingPage(
                          icon: Icons.memory_rounded, // Tech icon
                          title: 'Initialize Hub',
                          description: 'Your centralized workspace for academic deployment and daily tasks.'
                      ),
                      OnboardingPage(
                          icon: Icons.radar_rounded, // Radar/Scanner icon
                          title: 'Deep Focus Mode',
                          description: 'Engage course-specific timers to maximize cognitive output.'
                      ),
                      OnboardingPage(
                          icon: Icons.terminal_rounded, // Terminal icon
                          title: 'Execute Goals',
                          description: 'Track your streaks, compile your tasks, and build your future.'
                      ),
                    ],
                  ),
                ),

                // Futuristic Dot Indicator (Glowing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => _buildDot(index, context, isDark)),
                ),

                const SizedBox(height: 40),

                // Neon Main Action Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.transparent : Colors.black,
                        foregroundColor: isDark ? const Color(0xFF00E5FF) : Colors.white,
                        shadowColor: isDark ? const Color(0xFF00E5FF).withOpacity(0.5) : Colors.black26,
                        elevation: isDark ? 10 : 0, // Glow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: isDark ? const BorderSide(color: Color(0xFF00E5FF), width: 1.5) : BorderSide.none,
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == 2) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        } else {
                          _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic);
                        }
                      },
                      child: Text(
                          _currentPage == 2 ? '[ Deploy Workspace ]' : 'Next ==>',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context, bool isDark) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 24 : 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? const Color(0xFF00E5FF) : Colors.black)
            : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: isActive && isDark ? [
          const BoxShadow(color: Color(0xFF00E5FF), blurRadius: 8, spreadRadius: 1)
        ] : [], // Neon glow on active dot
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({super.key, required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // GLASSMORPHISM BLUR
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glowing Icon Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF00E5FF).withOpacity(0.1) : Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                      boxShadow: isDark ? [
                        BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.2), blurRadius: 30)
                      ] : [],
                    ),
                    child: Icon(icon, size: 80, color: isDark ? const Color(0xFF00E5FF) : Colors.black),
                  ),
                  const SizedBox(height: 50),
                  Text(
                      title,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: -0.5
                      ),
                      textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 16),
                  Text(
                      description,
                      style: TextStyle(fontSize: 15, color: isDark ? Colors.grey[400] : Colors.grey[700], height: 1.6),
                      textAlign: TextAlign.center
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