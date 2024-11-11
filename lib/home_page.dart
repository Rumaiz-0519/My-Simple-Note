import 'package:flutter/material.dart';
import 'create_note.dart';
import 'note_card.dart';
import 'note_model.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final fetchedNotes = await _dbHelper.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  void onNewNoteCreated(Note note) async {
    final now = DateTime.now().toIso8601String();
    final newNote = Note(
      heading: note.heading,
      body: note.body,
      createdAt: now,
      updatedAt: now,
    );

    final insertResult = await _dbHelper.insertNote(newNote);
    if (insertResult > 0) {
      _loadNotes();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create the note.')),
      );
    }
  }

  void onNoteDeleted(int id) async {
    final deleteResult = await _dbHelper.deleteNote(id);
    if (deleteResult > 0) {
      _loadNotes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete the note.')),
      );
    }
  }

  void onNoteUpdated() async {
    _loadNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Notes"),
        centerTitle: true,
        actions: [
          
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              widget.onThemeChanged(!widget.isDarkMode);
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes available.'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteCard(
                  note: notes[index],
                  onNoteDeleted: onNoteDeleted,
                  onNoteUpdated: onNoteUpdated,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateNote(
                onNewNoteCreated: onNewNoteCreated,
              ),
            ),
          );

          if (result == true) {
            _loadNotes();
          }
        },
        tooltip: 'Create Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
