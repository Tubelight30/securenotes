import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/constants/secrets.dart';
import 'package:securenotes/models/note.dart';
import 'package:http/http.dart' as http;

class SearchNotesController extends GetxController {
  final isSearching = false.obs;
  final searchResults = <Note>[].obs;

  // Replace with your actual API key
  static String apiKey = Secrets.geminiAPIKEY;
  static const String geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';

  Future<void> searchNotes(String query, List<Note> allNotes) async {
    try {
      isSearching.value = true;

      // Prepare the notes context and query
      final notesContext = allNotes
          .map((note) =>
              "Note ID: ${note.id}\nTitle: ${note.title}\nContent: ${note.content}")
          .join('\n\n');

      final promptText = '''
      Given these notes:
      $notesContext

      Find the most relevant notes for the search query: "$query"
      Return only the IDs of the relevant notes in a JSON array format like this: {"relevant_notes": ["id1", "id2"]}
      Do not include any explanations or additional text. Output only the JSON.
      ''';

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": promptText}
            ]
          }
        ]
      };

      print(promptText);
      final response = await http.post(
        Uri.parse('$geminiEndpoint?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Extract the text response from Gemini
        String generatedText =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        print('Generated Text: $generatedText');
        generatedText = generatedText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

// Print the cleaned generated text
        print('Cleaned Generated Text: $generatedText');
        if (generatedText == '{"relevant_notes": []}') {
          return;
        }
        // Parse the JSON response from the generated text
        // We need to handle potential formatting issues in the response
        try {
          final relevantNotesJson = json.decode(generatedText);
          print(relevantNotesJson);
          final relevantNoteIds =
              List<String>.from(relevantNotesJson['relevant_notes']);

          // Filter notes based on returned IDs
          searchResults.value = allNotes
              .where((note) => relevantNoteIds.contains(note.id))
              .toList();
        } catch (e) {
          throw Exception('Failed to parse search results: $e');
        }
      } else {
        throw Exception('Gemini API request failed: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Search Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    searchResults.clear();
  }
}
