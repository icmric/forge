import 'package:flutter/material.dart';
import 'package:forge/data/definition.dart';

class EditorPage extends StatefulWidget {
  Note currentNote;
  EditorPage({super.key, required this.currentNote});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  bool isSaving = false;
  @override
  Widget build(BuildContext context) {
    List<String> content = widget.currentNote.content;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Editor')),
      ),
      body: TextFormField(
        initialValue: content.map((item) => item).join('\n'),
        expands: true,
        maxLines: null,
        minLines: null,
        onChanged: (newValue) {
          saveNote(newValue);
        },
      ),
      //ListView(
      //  children: content.map((item) => Text(item)).toList(),
      //),
    );
  }

  // Make this not async and more generic
  // Add another function that calls this which is async, must save last edit too
  // this might work for a full note when images and drawing is included?
  Future<void> saveNote(String update) async {
    if (isSaving) {
      print("Already Saving");
      return;
    }

    isSaving = true;
    print("Saving...");
    List<String> updateList = update!.split('\n');
    widget.currentNote.content = updateList;
    print(widget.currentNote.content);

    await Future.delayed(const Duration(seconds: 1));

    isSaving = false;
  }
}
