import 'package:flutter/material.dart';
import 'package:mindfulmoments/models/note.dart';
import 'package:mindfulmoments/repo/notesrepo.dart';

class AddnoteScreen extends StatefulWidget {
  final Note? note;
  const AddnoteScreen({super.key, this.note});

  @override
  State<AddnoteScreen> createState() => _AddnoteScreenState();
}

class _AddnoteScreenState extends State<AddnoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        centerTitle: true,
        actions: [
          widget.note != null
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text(
                            'Are you sure you want to delete this note?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              _deleteNote();
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context), // Close the dialog
                            child: const Text('No'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                )
              : const SizedBox(),
          IconButton(
            onPressed: widget.note == null ? _insertNote : _updateNote,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'title',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Express yourself...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  _insertNote() async {
    final note = Note(
      title: _titleController.text,
      description: _descriptionController.text,
      createdAt: DateTime.now(),
    );
    await Notesrepo.insert(note: note);
    Navigator.pop(context);
  }

  _updateNote() async {
    final note = Note(
      id: widget.note!.id!,
      title: _titleController.text,
      description: _descriptionController.text,
      createdAt: widget.note!.createdAt,
    );
    await Notesrepo.update(note: note);
    Navigator.pop(context);
  }

  _deleteNote() async {
    Notesrepo.delete(note: widget.note!).then((e) {
      Navigator.pop(context);
    });
  }
}
