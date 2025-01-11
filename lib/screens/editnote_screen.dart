// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:markdown_editable_textinput/format_markdown.dart';
// import 'package:securenotes/controller/note_controller.dart';
// import 'package:securenotes/models/note.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown_editable_textinput/markdown_text_input.dart';

// class EditNoteScreen extends StatefulWidget {
//   final Note note;

//   EditNoteScreen({Key? key, required this.note}) : super(key: key);

//   @override
//   _EditNoteScreenState createState() => _EditNoteScreenState();
// }

// class _EditNoteScreenState extends State<EditNoteScreen> {
//   final NoteController noteController = Get.find<NoteController>();
//   bool isPreviewMode = true;

//   @override
//   void initState() {
//     super.initState();
//     noteController.titleController.text = widget.note.title;
//     noteController.contentController.text = widget.note.content;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Note'),
//         actions: [
//           IconButton(
//             icon: Icon(isPreviewMode ? Icons.edit : Icons.preview),
//             onPressed: () {
//               setState(() {
//                 isPreviewMode = !isPreviewMode;
//               });
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: noteController.titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//               ),
//               SizedBox(height: 16),
//               Expanded(
//                 child: isPreviewMode
//                     ? Markdown(
//                         data: noteController.contentController.text,
//                         selectable: true,
//                       )
//                     : MarkdownTextInput(
//                         (String value) =>
//                             noteController.contentController.text = value,
//                         noteController.contentController.text,
//                         label: 'Content',
//                         maxLines: 14,
//                         actions: MarkdownType.values,
//                       ),
//               ),
//               SizedBox(
//                 height: kBottomNavigationBarHeight + 20,
//               )
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         tooltip: 'Save Note',
//         onPressed: () {
//           noteController.updateNote(widget.note.id);
//           Get.back();
//         },
//         child: Icon(Icons.save),
//       ),
//     );
//   }
// }
//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:securenotes/constants/utils.dart';
import 'package:securenotes/controller/note_controller.dart';
import 'package:securenotes/models/note.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:url_launcher/url_launcher.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  NoteController noteController =
      Get.find<NoteController>(tag: 'note_controller');
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
      // backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Color(0xff403B36),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Center(
          child: Text(
            'Edit Note',
            style: GoogleFonts.nunito(
              color: Color(0xff403B36),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isPreviewMode ? Icons.edit : Icons.preview,
              color: Color(0xff403B36),
            ),
            onPressed: () {
              setState(() {
                isPreviewMode = !isPreviewMode;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: noteController.titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: GoogleFonts.nunito(
                      color: Color(0xff403B36),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: GoogleFonts.nunito(
                    color: Color(0xff595550),
                    fontSize: 16,
                    // fontWeight: FontWeight.w10,
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: isPreviewMode
                        ? Markdown(
                            data: noteController.contentController.text,
                            selectable: true,
                            styleSheet: MarkdownStyleSheet(
                              p: GoogleFonts.nunito(
                                color: Color(0xff595550),
                                fontSize: 16,
                              ),
                            ),
                            onTapLink: (String text, String? href,
                                String title) async {
                              if (href != null) {
                                final Uri url = Uri.parse(href);
                                try {
                                  await launchUrl(url,
                                      mode: LaunchMode.inAppBrowserView);
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'Could not open link: $href',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              }
                            },
                          )
                        : SingleChildScrollView(
                            child: MarkdownTextInput(
                              (String value) =>
                                  noteController.contentController.text = value,
                              noteController.contentController.text,
                              label: 'Content',
                              maxLines: null,
                              // expands: true,
                              actions: MarkdownType.values,
                              textStyle: GoogleFonts.nunito(
                                color: Color(0xff595550),
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: MyColor.kOrange,
          onPressed: () {
            noteController.updateNote(widget.note.id);
            Get.back();
          },
          child: const Icon(
            Icons.save,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
