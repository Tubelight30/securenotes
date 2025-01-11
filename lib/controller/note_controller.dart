import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:securenotes/constants/secrets.dart';
import 'package:securenotes/controller/appwrite_service.dart';
import 'package:securenotes/models/note.dart';
import 'package:securenotes/screens/onboard_screen.dart';
import 'package:securenotes/utils/encryption_utils.dart';

class NoteController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  final isLoading = false.obs;
  final notes = <Note>[].obs;
  late String encryptionKey;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final RxBool isLocationEnabled = false.obs;
  Position? currentPosition;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  void _initialize() async {
    bool success = await _initEncryptionKey();
    if (success) {
      fetchNotes();
    }
  }

  Future<bool> _initEncryptionKey() async {
    try {
      encryptionKey = await EncryptionUtils.getEncryptionKey();
      // throw Exception('idk what happened');
      return true;
    } catch (e) {
      Get.snackbar(
        'Encryption Key Error',
        'Failed to retrieve encryption key: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
      );
      await appwriteService.account.deleteSession(sessionId: 'current');
      Get.offAll(const OnBoardScreen());
      return false;
    }
  }

  Future<bool> requestLocationPermission() async {
    final status = await permission.Permission.location.request();
    return status.isGranted;
  }

  Future<bool> toggleLocation() async {
    if (!isLocationEnabled.value) {
      final hasPermission = await requestLocationPermission();
      if (hasPermission) {
        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          currentPosition = position;
          isLocationEnabled.value = true;
          update();
          // Get.snackbar(
          //   'Location found',
          //   position.toString(),
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          //   snackPosition: SnackPosition.BOTTOM,
          // );
          return true;
        } catch (e) {
          Get.snackbar(
            'Location Error',
            'Failed to get location: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Permission Denied',
          'Location permission is denied. Cannot enable location.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } else {
      currentPosition = null;
      isLocationEnabled.value = false;
      return true;
    }
  }

  Future<void> createNote() async {
    isLoading.value = true;
    update();

    try {
      final user = await appwriteService.account.get();
      final now = DateTime.now();

      final encryptedTitle =
          EncryptionUtils.encrypt(titleController.text, encryptionKey);
      final encryptedContent =
          EncryptionUtils.encrypt(contentController.text, encryptionKey);
      // final result = await appwriteService.database.createDocument(
      //   databaseId: Secrets.databaseId,
      //   collectionId:
      //       Secrets.notesCollectionId, // Add this to your Secrets class
      //   documentId: ID.unique(),
      //   data: {
      //     'userId': user.$id,
      //     'title': encryptedTitle,
      //     'content': encryptedContent,
      //     'createdAt': now.toIso8601String(),
      //     'updatedAt': now.toIso8601String(),
      //   },
      // );
      // if (isLocationEnabled.value && currentPosition != null) {
      //   data['latitude'] = currentPosition!.latitude;
      //   data['longitude'] = currentPosition!.longitude;
      // }
      final data = <String, dynamic>{
        'userId': user.$id,
        'title': encryptedTitle,
        'content': encryptedContent,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };
      print('Is Location Enabled: ${isLocationEnabled.value}');
      print('Current Position: $currentPosition');
      if (isLocationEnabled.value && currentPosition != null) {
        data['latitude'] = currentPosition!.latitude;
        data['longitude'] = currentPosition!.longitude;
      }
      print(data);
      final result = await appwriteService.database.createDocument(
        databaseId: Secrets.databaseId,
        collectionId: Secrets.notesCollectionId,
        documentId: ID.unique(),
        data: data,
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
      update();
      titleController.clear();
      contentController.clear();

      // Get.snackbar(
      //   'Note Created',
      //   'Your note has been successfully created',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
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
      print("key in fetch " + encryptionKey);
      notes.value = result.documents.map((doc) {
        String title = doc.data['title'];
        String content = doc.data['content'];
        final decryptedTitle = EncryptionUtils.decrypt(title, encryptionKey);
        final decryptedContent =
            EncryptionUtils.decrypt(content, encryptionKey);
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
          EncryptionUtils.encrypt(titleController.text, encryptionKey);
      final encryptedContent =
          EncryptionUtils.encrypt(contentController.text, encryptionKey);
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

  Future<void> deleteNote(String noteId) async {
    try {
      await appwriteService.database.deleteDocument(
        databaseId: Secrets.databaseId,
        collectionId: Secrets.notesCollectionId,
        documentId: noteId,
      );
      //show snackbar upon success
      Get.snackbar(
        'Note Deleted',
        'Your note has been successfully deleted',
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}
