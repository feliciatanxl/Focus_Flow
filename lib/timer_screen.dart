import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class TimerScreen extends StatefulWidget {
  final String? taskName;

  const TimerScreen({super.key, this.taskName});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const int pomodoroDuration = 25 * 60;
  int _secondsRemaining = pomodoroDuration;
  Timer? _timer;
  bool _isRunning = false;

  String _selectedCourse = 'General Study';
  final List<String> _courses = [
    'General Study',
    'Intro to Computer Science',
    'Calculus I',
    'Physics 101',
    'English Literature'
  ];

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer!.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = pomodoroDuration;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the ThemeBrain!
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryColor = isDark ? const Color(0xFF00E5FF) : Colors.blueAccent; // Cyber Cyan

    // Calculate progress for the ring
    double progress = 1 - (_secondsRemaining / pomodoroDuration);

    return Scaffold(
      extendBodyBehindAppBar: true, // Let gradient flow behind App Bar
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Execution Module', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, color: isDark ? Colors.white : Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- 2. TARGET DIRECTIVE (Task Name) ---
                Text(
                  widget.taskName != null ? 'TARGET DIRECTIVE:' : 'AWAITING DIRECTIVE...',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: isDark ? Colors.grey[500] : Colors.grey[600]
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    widget.taskName ?? 'General Execution',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        height: 1.2
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // --- 3. GLASSMORPHIC COURSE DROPDOWN ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white, width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.05), blurRadius: 10)],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCourse,
                          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          icon: Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                          style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                          items: _courses.map((String course) {
                            return DropdownMenuItem<String>(
                              value: course,
                              child: Text(course),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() => _selectedCourse = newValue!);
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // --- 4. NEON PROGRESS RING & TIMER ---
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Glowing Shadow (Dark Mode Only)
                      if (isDark)
                        Container(
                          width: 270,
                          height: 270,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: primaryColor.withOpacity(0.15), blurRadius: 50, spreadRadius: 10)
                            ],
                          ),
                        ),

                      // Animated Progress Ring
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 12,
                          backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          strokeCap: StrokeCap.round,
                        ),
                      ),

                      // Inner Glass Circle
                      ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.white.withOpacity(0.02) : Colors.white.withOpacity(0.5),
                              border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white, width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isRunning ? 'ACTIVE' : 'STANDBY',
                                  style: TextStyle(
                                      color: _isRunning ? primaryColor : (isDark ? Colors.grey[500] : Colors.grey),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      fontSize: 12
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatTime(_secondsRemaining),
                                  style: TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? Colors.white : Colors.black87,
                                    fontFeatures: const [FontFeature.tabularFigures()], // Keeps text from jumping
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // --- 5. GLASSMORPHIC CONTROL DECK ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reboot Button
                    IconButton(
                      iconSize: 32,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: _resetTimer,
                      tooltip: 'Reboot',
                    ),
                    const SizedBox(width: 24),

                    // Main Action Button (Neon Glow)
                    GestureDetector(
                      onTap: _isRunning ? _pauseTimer : _startTimer,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRunning ? (isDark ? const Color(0xFFFF9100) : Colors.orangeAccent) : primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: (_isRunning ? Colors.orangeAccent : primaryColor).withOpacity(isDark ? 0.4 : 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8)
                            )
                          ],
                        ),
                        child: Icon(
                            _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 40,
                            color: Colors.white
                        ),
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Suspend/Stop Button
                    IconButton(
                      iconSize: 32,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      icon: const Icon(Icons.stop_rounded),
                      onPressed: _pauseTimer,
                      tooltip: 'Suspend',
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}