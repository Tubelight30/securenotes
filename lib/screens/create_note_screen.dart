import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:securenotes/constants/utils.dart';
import 'package:securenotes/controller/note_controller.dart';
import 'package:securenotes/models/note.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:securenotes/screens/dashboard_screen.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  NoteController noteController =
      Get.find<NoteController>(tag: 'note_controller');
  bool isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    noteController.titleController.clear();
    noteController.contentController.clear();
  }

  @override
  void dispose() {
    noteController.isLocationEnabled.value = false;
    noteController.currentPosition = null;
    super.dispose();
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
            'Create Note',
            style: GoogleFonts.nunito(
              color: Color(0xff403B36),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Obx(
            () {
              return IconButton(
                icon: Icon(
                  noteController.isLocationEnabled.value
                      ? Icons.location_on
                      : Icons.location_off,
                  color: noteController.isLocationEnabled.value
                      ? Colors.green
                      : Colors.grey,
                ),
                onPressed: () async {
                  await noteController.toggleLocation();
                },
              );
            },
          ),
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
                Container(
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
          onPressed: () async {
            if (noteController.isLocationEnabled.value &&
                noteController.currentPosition == null) {
              bool locationFetched = await noteController.toggleLocation();
              if (!locationFetched) {
                // Handle the case where location couldn't be fetched
                Get.snackbar(
                  'location error',
                  'Failed to get location',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
            }

            // await noteController.createNote();
            // Get.offAll(DashBoardScreen());
            await noteController.createNote();
            Get.offAll(DashBoardScreen());

            // noteController.updateNote(widget.note.id);
            // Get.back();
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
