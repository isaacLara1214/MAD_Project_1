import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  String _currentMood = 'No mood selected';
  List<int> _moodData = [0, 0, 0]; // Happy, Neutral, Sad counts

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _moodData = [
        prefs.getInt('happy') ?? 0,
        prefs.getInt('neutral') ?? 0,
        prefs.getInt('sad') ?? 0,
      ];
    });
  }

  Future<void> _saveMood(String mood) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentMood = 'Current mood: $mood';
      switch (mood) {
        case 'Happy':
          _moodData[0] = (prefs.getInt('happy') ?? 0) + 1;
          prefs.setInt('happy', _moodData[0]);
          break;
        case 'Neutral':
          _moodData[1] = (prefs.getInt('neutral') ?? 0) + 1;
          prefs.setInt('neutral', _moodData[1]);
          break;
        case 'Sad':
          _moodData[2] = (prefs.getInt('sad') ?? 0) + 1;
          prefs.setInt('sad', _moodData[2]);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxCount = _moodData.reduce((a, b) => a > b ? a : b);
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_currentMood, style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodButton(Icons.sentiment_very_satisfied, 'Happy'),
                _buildMoodButton(Icons.sentiment_neutral, 'Neutral'),
                _buildMoodButton(Icons.sentiment_very_dissatisfied, 'Sad'),
              ],
            ),
            SizedBox(height: 40),
            Text('Your Mood This Week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            // Custom bar chart
            Container(
              height: 200,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar('Happy', _moodData[0], maxCount, Colors.green),
                        _buildBar('Neutral', _moodData[1], maxCount, Colors.blue),
                        _buildBar('Sad', _moodData[2], maxCount, Colors.red),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Happy', style: TextStyle(color: Colors.green)),
                      Text('Neutral', style: TextStyle(color: Colors.blue)),
                      Text('Sad', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(IconData icon, String mood) {
    return IconButton(
      icon: Icon(icon, size: 40),
      color: _getMoodColor(mood),
      onPressed: () => _saveMood(mood),
    );
  }

  Widget _buildBar(String label, int value, int maxValue, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('$value'),
            SizedBox(height: 4),
            Container(
              height: maxValue > 0 ? (value / maxValue) * 150 : 0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Happy': return Colors.green;
      case 'Neutral': return Colors.blue;
      case 'Sad': return Colors.red;
      default: return Colors.grey;
    }
  }
}