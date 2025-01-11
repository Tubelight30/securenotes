// test/note_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:securenotes/controller/appwrite_service.dart';
import 'package:securenotes/controller/note_controller.dart';
import 'package:securenotes/models/note.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class MockAppwriteService extends Mock implements AppwriteService {}

class MockDatabase extends Mock implements Databases {}

void main() {
  group('NoteController Fetch Notes Test', () {
    late NoteController noteController;
    late MockAppwriteService mockAppwriteService;
    late MockDatabase mockDatabase;

    setUp(() {
      Get.reset();
      mockAppwriteService = MockAppwriteService();
      mockDatabase = MockDatabase();

      when(mockAppwriteService.database).thenReturn(mockDatabase);
      Get.put<AppwriteService>(mockAppwriteService);

      noteController = NoteController();
      Get.put<NoteController>(noteController);
    });

    test('fetchNotes retrieves notes and updates the notes list', () async {
      // Arrange
      final mockDocuments = DocumentList(
        total: 2,
        documents: [
          Document(
            $id: 'note1',
            $collectionId: 'collection_id',
            $databaseId: 'database_id',
            $createdAt: '2022-01-01T00:00:00Z',
            $updatedAt: '2022-01-01T00:00:00Z',
            $permissions: [],
            data: {
              'userId': 'user_id',
              'title': 'Encrypted Title 1',
              'content': 'Encrypted Content 1',
              'createdAt': '2022-01-01T00:00:00Z',
              'updatedAt': '2022-01-01T00:00:00Z',
            },
          ),
          Document(
            $id: 'note2',
            $collectionId: 'collection_id',
            $databaseId: 'database_id',
            $createdAt: '2022-01-02T00:00:00Z',
            $updatedAt: '2022-01-02T00:00:00Z',
            $permissions: [],
            data: {
              'userId': 'user_id',
              'title': 'Encrypted Title 2',
              'content': 'Encrypted Content 2',
              'createdAt': '2022-01-02T00:00:00Z',
              'updatedAt': '2022-01-02T00:00:00Z',
            },
          ),
        ],
      );

      // Mock the database.listDocuments method
      // when(mockDatabase.listDocuments(
      //   databaseId: any<String>(named: 'databaseId'),
      //   collectionId: any<String>(named: 'collectionId'),
      //   queries: any<List<String>>(named: 'queries'),
      // )).thenAnswer((_) async => mockDocuments);

      // Act
      await noteController.fetchNotes();

      // Assert
      expect(noteController.notes.length, 2);
      expect(noteController.notes[0].title, 'Encrypted Title 1');
      expect(noteController.notes[1].title, 'Encrypted Title 2');
    });
  });
}
