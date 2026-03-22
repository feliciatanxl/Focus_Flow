import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'login_screen.dart';

void main() {
  runApp(
    // 1. Wrap your entire app in the Provider so Dark Mode works everywhere
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const FocusFlowApp(),
    ),
  );
}

// 2. THE APP SETUP (Now listening to the ThemeProvider!)
class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // --- LIGHT AND DARK THEME SETTINGS ---
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF4F6F9),
              primaryColor: Colors.blueAccent,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black87,
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF121212),
              primaryColor: Colors.blueAccent,
              cardColor: const Color(0xFF1E1E1E),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),

            home: const SplashScreen(), // Keeps your awesome Splash Screen!
          );
        }
    );
  }
}

// 3. THE SPLASH SCREEN
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Notice I removed 'backgroundColor: Colors.white' so it adapts to Dark Mode!
      body: Center(
        child: Lottie.asset(
          'assets/SplashLogo.json',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

// 4. THE ONBOARDING TUTORIAL
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
    return Scaffold(
      // Removed hardcoded white background here too!
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  OnboardingPage(icon: Icons.check_circle_outline, title: 'Welcome to FocusFlow', description: 'The easiest way to organize your daily tasks.'),
                  OnboardingPage(icon: Icons.timer_outlined, title: 'Stay on Track', description: 'Build healthy habits and never miss a deadline.'),
                  OnboardingPage(icon: Icons.rocket_launch_outlined, title: 'Achieve Your Goals', description: 'Ready to boost your productivity? Let\'s go!'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage == 2
                      ? const SizedBox(width: 60)
                      : TextButton(
                    onPressed: () => _pageController.jumpToPage(2),
                    child: const Text('Skip', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_currentPage == 2) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      } else {
                        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      }
                    },
                    child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            )
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.blueAccent),
          const SizedBox(height: 40),
          Text(
              title,
              // Removed hardcoded black text so it turns white in dark mode
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center
          ),
          const SizedBox(height: 20),
          Text(description, style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}