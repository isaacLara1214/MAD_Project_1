import 'package:flutter/material.dart';
import 'package:mindfulmoments/repo/notesrepo.dart';
import 'package:mindfulmoments/widgets/item_note.dart';
import 'package:mindfulmoments/widgets/addnote.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key, required this.title});
  final String title;

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Refresh the notes
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Notesrepo.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No notes found. Start writing your first note!'),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                for (var note in snapshot.data!) ItemNote(note: note),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddnoteScreen(),
              ));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
