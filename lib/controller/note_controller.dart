import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/constants/secrets.dart';
import 'package:securenotes/controller/appwrite_service.dart';
import 'package:securenotes/models/note.dart';

class NoteController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  final isLoading = false.obs;
  final notes = <Note>[].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  Future<void> createNote() async {
    isLoading.value = true;
    update();

    try {
      final user = await appwriteService.account.get();
      final now = DateTime.now();

      final result = await appwriteService.database.createDocument(
        databaseId: Secrets.databaseId,
        collectionId:
            Secrets.notesCollectionId, // Add this to your Secrets class
        documentId: ID.unique(),
        data: {
          'userId': user.$id,
          'title': titleController.text,
          'content': contentController.text,
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      );

      final newNote = Note.fromMap(result.data);
      notes.insert(0, newNote);

      titleController.clear();
      contentController.clear();

      Get.snackbar(
        'Note Created',
        'Your note has been successfully created',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Create Note Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> fetchNotes() async {
    isLoading.value = true;
    update();

    try {
      final user = await appwriteService.account.get();
      final result = await appwriteService.database.listDocuments(
        databaseId: Secrets.databaseId,
        collectionId: Secrets.notesCollectionId,
        queries: [
          Query.equal('userId', user.$id),
          Query.orderDesc('updatedAt'),
        ],
      );

      notes.value =
          result.documents.map((doc) => Note.fromMap(doc.data)).toList();
    } catch (e) {
      Get.snackbar(
        'Fetch Notes Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> updateNote(String noteId) async {
    isLoading.value = true;
    update();

    try {
      final result = await appwriteService.database.updateDocument(
        databaseId: Secrets.databaseId,
        collectionId: Secrets.notesCollectionId,
        documentId: noteId,
        data: {
          'title': titleController.text,
          'content': contentController.text,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      final updatedNote = Note.fromMap(result.data);
      final index = notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        notes[index] = updatedNote;
      }

      Get.snackbar(
        'Note Updated',
        'Your note has been successfully updated',
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Update Note Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
