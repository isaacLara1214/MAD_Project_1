import 'package:flutter/material.dart';
import 'dart:async';

class GuidedExcercisePage extends StatefulWidget {
  const GuidedExcercisePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _GuidedExcercisePageState createState() => _GuidedExcercisePageState();
}

class _GuidedExcercisePageState extends State<GuidedExcercisePage>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _remainingTime = 180; // 3 minutes in seconds
  String _instruction = "Press Start to Begin";
  double _progress = 0.0; // Progress value for the progress bar
  bool _isExerciseStarted = false; // Track if the exercise has started

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 4), // Default duration for inhale/exhale
    );
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _startBreathingExercise() {
    setState(() {
      _isExerciseStarted = true;
      _instruction = "Inhale...";
    });

    _animationController.forward(); // Start with inhale animation

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime <= 0) {
          _timer.cancel();
          _animationController.stop();
          _instruction = "Exercise Complete!";
          _progress = 1.0; // Mark progress as complete
        } else {
          _remainingTime -= 1;
          _progress = (180 - _remainingTime) / 180; // Update progress

          // Update the instruction dynamically based on the current time
          final cycle = (_remainingTime % 12) ~/ 4;
          if (cycle == 0) {
            _instruction = "Inhale...";
            _animationController.duration = const Duration(seconds: 4);
            _animationController.forward(); // Animate to larger size
          } else if (cycle == 1) {
            _instruction = "Hold...";
            _animationController.stop(); // Pause animation during hold
          } else {
            _instruction = "Exhale...";
            _animationController.duration = const Duration(seconds: 4);
            _animationController.reverse(); // Animate to smaller size
          }
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _instruction,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: _progress, // Bind progress value to the progress bar
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                minHeight: 10,
              ),
              const SizedBox(height: 20),
              Text(
                "Time Remaining: ${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 40),
              if (!_isExerciseStarted)
                ElevatedButton(
                  onPressed: _startBreathingExercise,
                  child: const Text('Start Exercise'),
                ),
              if (_isExerciseStarted)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('End Exercise'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
