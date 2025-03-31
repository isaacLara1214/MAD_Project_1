import 'package:flutter/material.dart';
import 'package:mindfulmoments/providers/notes_provider.dart';
import 'package:mindfulmoments/widgets/item_note.dart';
import 'package:mindfulmoments/widgets/addnote.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<NotesProvider>(
        builder: (context, provider, child) {
          return provider.notes.isEmpty
              ? const Center(
                  child: Text('No notes found. Start writing your first note'))
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: provider.notes
                      .map((e) => ItemNote(
                            note: e,
                          ))
                      .toList(),
                );
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
