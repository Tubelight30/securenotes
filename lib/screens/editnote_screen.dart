import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:securenotes/controller/note_controller.dart';
import 'package:securenotes/models/note.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final NoteController noteController = Get.find<NoteController>();
  bool isPreviewMode = true;

  @override
  void initState() {
    super.initState();
    noteController.titleController.text = widget.note.title;
    noteController.contentController.text = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(isPreviewMode ? Icons.edit : Icons.preview),
            onPressed: () {
              setState(() {
                isPreviewMode = !isPreviewMode;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: noteController.titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: isPreviewMode
                  ? Markdown(data: noteController.contentController.text)
                  : MarkdownTextInput(
                      (String value) =>
                          noteController.contentController.text = value,
                      noteController.contentController.text,
                      label: 'Content',
                      maxLines: 14,
                      actions: MarkdownType.values,
                    ),
            ),
            // SizedBox(
            //   height: ,
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save Note',
        onPressed: () {
          noteController.updateNote(widget.note.id);
          Get.back();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
