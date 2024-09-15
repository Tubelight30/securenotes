import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/constants/secrets.dart';
import 'package:securenotes/controller/appwrite_service.dart';
import 'package:securenotes/models/note.dart';
import 'package:securenotes/utils/encryption_utils.dart';

class NoteController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  final isLoading = false.obs;
  final notes = <Note>[].obs;
  late String _encryptionKey;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initEncryptionKey();
    fetchNotes();
  }

  Future<void> _initEncryptionKey() async {
    _encryptionKey = await EncryptionUtils.getEncryptionKey();
  }

  Future<void> createNote() async {
    isLoading.value = true;
    update();

    try {
      final user = await appwriteService.account.get();
      final now = DateTime.now();

      final encryptedTitle =
          EncryptionUtils.encrypt(titleController.text, _encryptionKey);
      final encryptedContent =
          EncryptionUtils.encrypt(contentController.text, _encryptionKey);
      final result = await appwriteService.database.createDocument(
        databaseId: Secrets.databaseId,
        collectionId:
            Secrets.notesCollectionId, // Add this to your Secrets class
        documentId: ID.unique(),
        data: {
          'userId': user.$id,
          'title': encryptedTitle,
          'content': encryptedContent,
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      );

      // final newNote = Note.fromMap(result.data);
      final newNote = Note(
        id: result.data['\$id'],
        userId: result.data['userId'],
        title: titleController.text,
        content: contentController.text,
        createdAt: DateTime.parse(result.data['createdAt']),
        updatedAt: DateTime.parse(result.data['updatedAt']),
      );
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
      print("key in fetch " + _encryptionKey);
      notes.value = result.documents.map((doc) {
        String title = doc.data['title'];
        String content = doc.data['content'];
        final decryptedTitle = EncryptionUtils.decrypt(title, _encryptionKey);
        final decryptedContent =
            EncryptionUtils.decrypt(content, _encryptionKey);
        print('Retrieved encrypted title: $title');
        print('Retrieved encrypted content: $content');

        return Note(
          id: doc.$id,
          userId: doc.data['userId'],
          title: decryptedTitle,
          content: decryptedContent,
          createdAt: DateTime.parse(doc.data['createdAt']),
          updatedAt: DateTime.parse(doc.data['updatedAt']),
        );
      }).toList();
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
      final encryptedTitle =
          EncryptionUtils.encrypt(titleController.text, _encryptionKey);
      final encryptedContent =
          EncryptionUtils.encrypt(contentController.text, _encryptionKey);
      final result = await appwriteService.database.updateDocument(
        databaseId: Secrets.databaseId,
        collectionId: Secrets.notesCollectionId,
        documentId: noteId,
        data: {
          'title': encryptedTitle,
          'content': encryptedContent,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      final updatedNote = Note(
        id: result.data['\$id'],
        userId: result.data['userId'],
        title: titleController.text,
        content: contentController.text,
        createdAt: DateTime.parse(result.data['createdAt']),
        updatedAt: DateTime.parse(result.data['updatedAt']),
      );
      final index = notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        notes[index] = updatedNote;
      }
      titleController.clear();
      contentController.clear();
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
