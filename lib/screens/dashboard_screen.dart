import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securenotes/constants/utils.dart';
import 'package:securenotes/controller/logout_controller.dart';
import 'package:securenotes/controller/note_controller.dart';
import 'package:securenotes/controller/search_notes_controller.dart';
import 'package:securenotes/controller/userprofile_controller.dart';
import 'package:securenotes/models/note.dart';
import 'package:securenotes/screens/create_note_screen.dart';
import 'package:securenotes/screens/editnote_screen.dart';
import 'package:securenotes/screens/onboard_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final UserProfileController userProfileController =
      Get.put(UserProfileController());

  NoteController noteController =
      Get.put(NoteController(), tag: 'note_controller');

  final SearchNotesController searchController =
      Get.put(SearchNotesController());

  final TextEditingController searchQueryController = TextEditingController();

  final LogoutController logoutController = Get.put(LogoutController());

  final Map<int, String> month = {
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

  void _showSearchDialog(BuildContext context) {
    showDialog(
      // barrierColor: MyColor.kScaffoldBackground,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Search Notes',
            style: GoogleFonts.nunito(
              color: Color(0xff403B36),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: searchQueryController,
            style: GoogleFonts.nunito(
              color: Color(0xff403B36),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Enter search query...',
              hintStyle: GoogleFonts.nunito(
                color: Color(0xff403B36),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (query) async {
              if (query.isNotEmpty) {
                await searchController.searchNotes(query, noteController.notes);
                Navigator.pop(context);
                _showSearchResults(context);
                searchQueryController.clear();
              }
            },
          ),
          actions: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (searchQueryController.text.isNotEmpty) {
                    await searchController.searchNotes(
                      searchQueryController.text,
                      noteController.notes,
                    );
                    Navigator.pop(context);
                    _showSearchResults(context);
                    searchQueryController.clear();
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: MyColor.kOrange,
                  ),
                  child: Center(
                    child: Text(
                      "Search",
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSearchResults(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (searchController.isSearching.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (searchController.searchResults.isEmpty) {
              return const Center(
                child: Text('No matching notes found'),
              );
            }

            return ListView.builder(
              itemCount: searchController.searchResults.length,
              itemBuilder: (context, index) {
                final note = searchController.searchResults[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0xffFFFDFA),
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => EditNoteScreen(note: note));
                    },
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  // void _showCreateNoteDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Create New Note'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: noteController.titleController,
  //               decoration: const InputDecoration(hintText: 'Title'),
  //             ),
  //             TextField(
  //               controller: noteController.contentController,
  //               decoration: const InputDecoration(hintText: 'Content'),
  //               maxLines: 3,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               noteController.createNote();
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Create'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _refresh() async {
    await noteController.fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: kToolbarHeight,
            ),
            // DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: const Color(0xff6F6FC8),
            //   ),
            //   child: Text(
            //     'Menu',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 24,
            //     ),
            //   ),
            // ),
            CircleAvatar(
              radius: 50,
              backgroundColor: MyColor.kOrange,
              child: Obx(
                () {
                  if (userProfileController.isLoading.value) {
                    return const CircularProgressIndicator();
                  }
                  return Text(
                    userProfileController.loggedInUser!.name[0].toUpperCase(),
                    style: GoogleFonts.nunito(
                      fontSize: 40,
                      color: const Color(0xff403B36),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                final ans = await logoutController.logout();
                if (ans) {
                  Get.snackbar(
                    'Logout Successful',
                    'You have successfully logged out',
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  Get.offAll(const OnBoardScreen());
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Recent Notes",
            style: GoogleFonts.nunito(
              color: const Color(0xff403B36),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              return _showSearchDialog(context);
            },
            icon: const Icon(
              Icons.search,
              color: Color(0xff403B36),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () {
          if (noteController.notes.isNotEmpty &&
              !noteController.isLoading.value) {
            return SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: MyColor.kOrange,
                onPressed: () {
                  // _showCreateNoteDialog(context);
                  Get.to(() => const CreateNoteScreen());
                },
                child: const Icon(
                  Icons.note_add_outlined,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      body: RefreshIndicator(
        color: MyColor.kOrange,
        onRefresh: _refresh,
        child: Obx(
          () {
            if (noteController.isLoading.value) {
              return Center(
                child: Text(
                  "Fetching your encrypted notes...",
                  style: GoogleFonts.nunito(
                    color: Color(0xff403B36),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            if (noteController.notes.isEmpty &&
                noteController.isLoading.value == false) {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: Image.asset(
                      "images/no_note.png",
                      height: MediaQuery.of(context).size.height * 0.36,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Center(
                    child: Text(
                      "Create Your First Note",
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff403B36),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Got a thought? Jot it down and let the encryption magic begin!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff595550),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      // _showCreateNoteDialog(context);
                      Get.to(() => CreateNoteScreen());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyColor.kOrange,
                      ),
                      child: Center(
                        child: Text(
                          "Create A Note",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kBottomNavigationBarHeight,
                  ),
                ],
              );
            }
            return ListView.builder(
              // gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
              // staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
              // crossAxisCount: 4,
              // crossAxisSpacing: 8,
              // mainAxisSpacing: 8,
              // ),
              padding: const EdgeInsets.only(
                bottom: kFloatingActionButtonMargin + 50,
              ),
              itemCount: noteController.notes.length,
              itemBuilder: (context, index) {
                Note note = noteController.notes[index];
                return Dismissible(
                  key: Key(note.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 1),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) async {
                    // final deletedNote = note;
                    noteController.notes.removeAt(index);
                    noteController.update();
                    await noteController.deleteNote(note.id);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFDFA),
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        note.title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: const Color(0xff595550),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        "${month[note.updatedAt.month]} ${note.updatedAt.day.toString()} ${note.updatedAt.hour.toString()}:${note.updatedAt.minute.toString()}",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        note.content
                            .split('\n')
                            .first, // Only show the first line
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: Color(0xff595550),
                        ),
                      ),
                      onTap: () {
                        Get.to(() => EditNoteScreen(note: note));
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
