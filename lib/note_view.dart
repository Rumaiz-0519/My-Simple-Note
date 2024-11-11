import 'package:flutter/material.dart';
import 'note_model.dart';
import 'create_note.dart';
import 'database_helper.dart';

class NoteView extends StatefulWidget {
  const NoteView({
    super.key,
    required this.note,
    required this.onNoteDeleted,
    required this.onNoteUpdated,
  });

  final Note note;
  final Function(int) onNoteDeleted;
  final Function() onNoteUpdated;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late Note currentNote;

  @override
  void initState() {
    super.initState();
    currentNote = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Note View"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Delete This?"),
                    content: Text(
                        "Note \"${currentNote.heading}\" will be deleted!"),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final deleteResult =
                              await dbHelper.deleteNote(currentNote.id!);
                          if (deleteResult > 0) {
                            widget.onNoteDeleted(currentNote.id!);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to delete the note.')),
                            );
                          }
                        },
                        child: const Text(
                          "DELETE",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("CANCEL"),
                      )
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Note',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentNote.heading,
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  currentNote.body,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateNote(
                onNewNoteCreated: (updatedNote) async {
                  final now = DateTime.now().toIso8601String();
                  final noteToUpdate = Note(
                    id: currentNote.id,
                    heading: updatedNote.heading,
                    body: updatedNote.body,
                    createdAt: currentNote.createdAt,
                    updatedAt: now,
                  );
                  final updateResult = await dbHelper.updateNote(noteToUpdate);
                  if (updateResult > 0) {
                    widget.onNoteUpdated();
                    setState(() {
                      currentNote = noteToUpdate;
                    });
                    Navigator.of(context).pop(true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to update the note.')),
                    );
                  }
                },
                note: currentNote,
                isEditing: true,
              ),
            ),
          );

          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note updated successfully!')),
            );
          }
        },
        tooltip: 'Edit Note',
      ),
    );
  }
}



