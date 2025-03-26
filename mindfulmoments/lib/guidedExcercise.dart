import 'package:flutter/material.dart';

class GuidedExcercisePage extends StatefulWidget {
  const GuidedExcercisePage({super.key, required this.title});
  final String title;

  @override
  _GuidedExcercisePageState createState() => _GuidedExcercisePageState();
}

class _GuidedExcercisePageState extends State<GuidedExcercisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
