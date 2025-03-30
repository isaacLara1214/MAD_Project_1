import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindfulmoments/guidedExcercise.dart';
import 'package:mindfulmoments/moodTracker.dart';
import 'package:mindfulmoments/journal.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  static const List<String> _affirmations = [
    '"Be present in all things and thankful for all things."',
    '"You are capable of amazing things."',
    '"Today is a new opportunity to grow."',
    '"Your thoughts shape your reality."',
    '"Progress, not perfection."',
    '"You are enough just as you are."',
    '"Breathe in calm, breathe out stress."',
  ];

  Future<String> _getRandomAffirmation() async {
    final prefs = await SharedPreferences.getInstance();
    final lastIndex = prefs.getInt('lastAffirmationIndex') ?? -1;
    
    int randomIndex;
    do {
      randomIndex = DateTime.now().millisecondsSinceEpoch % _affirmations.length;
    } while (randomIndex == lastIndex && _affirmations.length > 1);
    
    await prefs.setInt('lastAffirmationIndex', randomIndex);
    return _affirmations[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<String>(
          future: _getRandomAffirmation(),
          builder: (context, snapshot) {
            final affirmation = snapshot.data ?? _affirmations[0];
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Welcome to Mindful Moments",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Daily Affirmations",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        affirmation,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.black, thickness: 1),
                const SizedBox(height: 20),

                const Text("Guided Exercise",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildNavigationBox(context, "Start Breathing Exercise", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GuidedExcercisePage(title: "Guided Exercise")),
                  );
                }),

                const SizedBox(height: 20),

                const Text("Mood Tracker",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildNavigationBox(context, "Track My Mood", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoodTrackerPage(title: "Mood Tracker")),
                  );
                }),

                const SizedBox(height: 20),
                
                const Text("Journal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildNavigationBox(context, "Write in My Journal", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JournalPage(title: "Journal")),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavigationBox(BuildContext context, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}