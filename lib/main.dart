import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart';

void main() {
  runApp(const FocusFlowApp());
}

// 1. THE APP SETUP
class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// 2. THE SPLASH SCREEN
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
      backgroundColor: Colors.white,
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

// 3. THE ONBOARDING TUTORIAL
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
      backgroundColor: Colors.white,
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
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Text(description, style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}