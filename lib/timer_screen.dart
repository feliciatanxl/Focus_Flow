import 'package:flutter/material.dart';
import 'dart:async'; // We need this to make the clock actually tick!

class TimerScreen extends StatefulWidget {
  final String? taskName; // We can pass a specific task to this screen!

  const TimerScreen({super.key, this.taskName});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // 25 minutes = 1500 seconds
  static const int pomodoroDuration = 25 * 60;
  int _secondsRemaining = pomodoroDuration;
  Timer? _timer;
  bool _isRunning = false;

  // The Course/Module selector
  String _selectedCourse = 'General Study';
  final List<String> _courses = [
    'General Study',
    'Intro to Computer Science',
    'Calculus I',
    'Physics 101',
    'English Literature'
  ];

  // Starts the clock
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
          // When it hits 0, you could trigger an alarm or pop-up here!
        }
      });
    });
  }

  // Pauses the clock
  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  // Resets back to 25:00
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = pomodoroDuration;
    });
  }

  // Formats the seconds into standard MM:SS clock text
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always kill the timer when leaving the screen to save battery!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Focus Mode', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context), // Closes the timer
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // If they clicked a specific task, show it here!
            if (widget.taskName != null)
              Text(
                widget.taskName!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 20),

            // THE MODULE / COURSE DROP DOWN
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCourse,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
                  items: _courses.map((String course) {
                    return DropdownMenuItem<String>(
                      value: course,
                      child: Text(course),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCourse = newValue!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 60),

            // THE GIANT CLOCK
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    _formatTime(_secondsRemaining),
                    style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // THE CONTROLS (Play, Pause, Stop)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Reset Button
                IconButton(
                  iconSize: 36,
                  color: Colors.grey,
                  icon: const Icon(Icons.refresh),
                  onPressed: _resetTimer,
                ),
                const SizedBox(width: 20),

                // Play / Pause Button
                FloatingActionButton.large(
                  backgroundColor: _isRunning ? Colors.orangeAccent : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 40),
                ),

                const SizedBox(width: 20),
                // Stop/Finish Button
                IconButton(
                  iconSize: 36,
                  color: Colors.grey,
                  icon: const Icon(Icons.stop_circle_outlined),
                  onPressed: () {
                    _pauseTimer();
                    // Could show a "Session Saved!" message here
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}