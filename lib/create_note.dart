import 'package:flutter/material.dart';
import 'note_model.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({
    super.key,
    required this.onNewNoteCreated,
    this.note,
    this.isEditing = false,
  });

  final Function(Note) onNewNoteCreated;
  final Note? note;
  final bool isEditing;

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final headingController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.note != null) {
      headingController.text = widget.note!.heading;
      bodyController.text = widget.note!.body;
    }
  }

  @override
  void dispose() {
    headingController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (headingController.text.isEmpty || bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both heading and body are required')),
      );
      return;
    }

    final note = Note(
      heading: headingController.text,
      body: bodyController.text,
      createdAt: widget.isEditing ? widget.note!.createdAt : '',
      updatedAt: widget.isEditing ? '' : '',
      id: widget.isEditing ? widget.note!.id : null,
    );

    widget.onNewNoteCreated(note);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: 'Save Note',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: headingController,
              style: const TextStyle(fontSize: 28),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Heading",
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Heading is required';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: bodyController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Text",
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        tooltip: 'Save Note',
        child: const Icon(Icons.save),
      ),
    );
  }
}
