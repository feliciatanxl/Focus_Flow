import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme_provider.dart';
import 'login_screen.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load the secret keys from your .env file
  await dotenv.load(fileName: ".env");

  // 3. Initialize Supabase BEFORE running the app
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // 4. Run the app
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
            // --- FROST THEME (Light) ---
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF5F5F5),
              primaryColor: Colors.black,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.light),
            ),
            // --- OBSIDIAN THEME (Dark) ---
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              primaryColor: Colors.white,
              cardColor: const Color(0xFF121212),
            ),
            home: const SplashScreen(),
          );
        }
    );
  }
}

// -------------------------------------------------------------------------
// 3. THE SPLASH SCREEN (Monochrome Boot Sequence)
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
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
            // Terminal-style loading text
            Text(
              'INITIALIZING_WORKSPACE...',
              style: TextStyle(
                fontFamily: 'Courier',
                color: isDark ? Colors.white54 : Colors.black54,
                letterSpacing: 2,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                backgroundColor: isDark ? Colors.white10 : Colors.black12,
                color: accentColor,
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
// 4. THE ONBOARDING TUTORIAL (Monochrome UI)
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
    final accentColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Minimal Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                      child: Text(
                          '< SKIP >',
                          style: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black38,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 12,
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
                          icon: Icons.grid_view_rounded,
                          title: 'INITIALIZE_HUB',
                          description: 'Your centralized workspace for academic deployment and daily tasks.'
                      ),
                      OnboardingPage(
                          icon: Icons.timer_outlined,
                          title: 'DEEP_FOCUS_MODE',
                          description: 'Engage course-specific timers to maximize cognitive output.'
                      ),
                      OnboardingPage(
                          icon: Icons.terminal_rounded,
                          title: 'EXECUTE_GOALS',
                          description: 'Track your streaks, compile your tasks, and build your future.'
                      ),
                    ],
                  ),
                ),

                // Solid Dot Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => _buildDot(index, isDark, accentColor)),
                ),

                const SizedBox(height: 40),

                // Solid Main Action Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                          _currentPage == 2 ? 'DEPLOY_WORKSPACE' : 'NEXT_SEQUENCE',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)
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

  Widget _buildDot(int index, bool isDark, Color accentColor) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 24 : 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isActive ? accentColor : (isDark ? Colors.white24 : Colors.black26),
        borderRadius: BorderRadius.circular(10),
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
    final accentColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Monochrome Icon Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                    ),
                    child: Icon(icon, size: 80, color: accentColor),
                  ),
                  const SizedBox(height: 50),
                  Text(
                      title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                          letterSpacing: 1
                      ),
                      textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 16),
                  Text(
                      description,
                      style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white54 : Colors.black54,
                          height: 1.6,
                          letterSpacing: 0.5
                      ),
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