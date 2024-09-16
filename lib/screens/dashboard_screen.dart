import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/controller/logout_controller.dart';
import 'package:securenotes/controller/note_controller.dart';
import 'package:securenotes/controller/userprofile_controller.dart';
import 'package:securenotes/models/note.dart';
import 'package:securenotes/screens/editnote_screen.dart';
import 'package:securenotes/screens/onboard_screen.dart';

class DashBoardScreen extends StatelessWidget {
  UserProfileController userProfileController =
      Get.put(UserProfileController());
  NoteController noteController = Get.put(NoteController());
  LogoutController logoutController = Get.put(LogoutController());
  DashBoardScreen({super.key});
  Map<int, String> month = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };
  void _showCreateNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController.titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: noteController.contentController,
                decoration: InputDecoration(hintText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                noteController.createNote();
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refresh() async {
    await noteController.fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Obx(
          () {
            if (userProfileController.isLoading.value) {
              return Text('Loading...');
            }
            return Text(
              "Welcome, " + userProfileController.loggedInUser!.name,
              style: TextStyle(
                color: Colors.white,
              ),
            );
          },
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff6F6FC8),
            ),
            onPressed: () async {
              final ans = await logoutController.logout();
              if (ans) {
                Get.snackbar(
                  'Logout Successful',
                  'You have successfully logged out',
                  backgroundColor: Colors.black,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
                Get.off(OnBoardScreen());
              }
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Color(0xff6F6FC8),
          onPressed: () {
            _showCreateNoteDialog(context);
          },
          child: Icon(
            Icons.note_add_outlined,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Obx(
          () {
            if (noteController.isLoading.value) {
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
            }
            return ListView.builder(
              itemCount: noteController.notes.length,
              itemBuilder: (context, index) {
                Note note = noteController.notes[index];
                return ListTile(
                  title: Text(note.title),
                  trailing: Text(
                    "${month[note.updatedAt.month]} ${note.updatedAt.day.toString()} ${note.updatedAt.hour.toString()}:${note.updatedAt.minute.toString()}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    note.content.split('\n').first, // Only show the first line
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Get.to(() => EditNoteScreen(note: note));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
