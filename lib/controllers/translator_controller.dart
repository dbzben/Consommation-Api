//translator_controller.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslatorController {
  List<Language> languages = [];
  String selectedSourcelanguage = '';
  String selectedTargetlanguage = '';
  List<String> recentTranslations = [];

//liste des langues
  Future<void> fetchLanguages() async {
    final url = 'https://text-translator2.p.rapidapi.com/getLanguages';
    print(url);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-RapidAPI-Key':
              'a50cecb5e6msh7019698d1a2aef4p1a8f42jsnbd95e27f9eb1',
          'X-RapidAPI-Host': 'text-translator2.p.rapidapi.com',
        },
      );
      print('Response status: ${response.statusCode}');
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        if (data.containsKey('data') && data['data'].containsKey('languages')) {
          final List<dynamic> languagesData = data['data']['languages'];

          languages = languagesData
              .map((languageData) => Language(
                    languageData['code'],
                    languageData['name'],
                  ))
              .toList();

          selectedSourcelanguage =
              languages.isNotEmpty ? languages[0].code : "";
          selectedTargetlanguage =
              languages.isNotEmpty ? languages[0].code : "";
        }
      } else {
        // Gérer les erreurs de l'API ici
        print(
            'Erreur lors de la récupération des langues. Code HTTP: ${response.statusCode}');
      }
    } catch (error) {
      // Gérer les erreurs ici
      print('Erreur lors de la récupération des langues: $error');
    }
  }

//traduire le texte
  Future<void> translateText(
    String sourceLanguage,
    String targetLanguage,
    String textToTranslate,
    TextEditingController resultTextEditingController,
  ) async {
    final url = 'https://text-translator2.p.rapidapi.com/translate';
    final headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'X-RapidAPI-Key': 'a50cecb5e6msh7019698d1a2aef4p1a8f42jsnbd95e27f9eb1',
      'X-RapidAPI-Host': 'text-translator2.p.rapidapi.com',
    };

    final body = {
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'text': textToTranslate,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('status') &&
            data['status'] == 'success' &&
            data.containsKey('data')) {
          final translatedText = data['data']['translatedText'];
          resultTextEditingController.text = translatedText;
        } else {
          print('Erreur de traduction: ${data['message']}');
        }
      } else {
        print(
            'Erreur lors de la traduction. Code HTTP: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la traduction: $error');
    }
  }

  void addRecentTranslation(String sourceLanguage, String sourceWord,
      String targetLanguage, String translatedWord) async {
    String formattedDate = DateTime.now().toLocal().toString();

    String entry =
        'From: $sourceLanguage "$sourceWord" To: $targetLanguage "$translatedWord" Date: $formattedDate';

    recentTranslations.insert(0, entry);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentTranslations', recentTranslations);

    // Print the recentTranslations list for debugging
    print('Recent Translations: $recentTranslations');
  }

  // Charge les traductions récentes depuis le stockage local
  Future<void> loadRecentTranslations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    recentTranslations = prefs.getStringList('recentTranslations') ?? [];
  }

  //liste des mots
  Future<List<Word>> fetchWords() async {
    final url = 'https://trouve-mot.fr/api/random/5';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));

      print('Response status: ${response.statusCode}');
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        List<Word> words = data.map((wordData) {
          return Word(
            wordData['name'],
            wordData['categorie'],
          );
        }).toList();

        return words;
      } else {
        // Handle API errors here
        print('Error fetching words. HTTP Code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle errors here
      print('Error fetching words: $error');
      return [];
    }
  }

  Future<String> translateeText(
    String sourceLanguage,
    String targetLanguage,
    String textToTranslate,
  ) async {
    final url = 'https://text-translator2.p.rapidapi.com/translate';
    final headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'X-RapidAPI-Key': 'a50cecb5e6msh7019698d1a2aef4p1a8f42jsnbd95e27f9eb1',
      'X-RapidAPI-Host': 'text-translator2.p.rapidapi.com',
    };

    final body = {
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'text': textToTranslate,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('status') &&
            data['status'] == 'success' &&
            data.containsKey('data')) {
          final translatedText = data['data']['translatedText'];
          return translatedText;
        } else {
          print('Erreur de traduction: ${data['message']}');
        }
      } else {
        print(
            'Erreur lors de la traduction. Code HTTP: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la traduction: $error');
    }

    // Return an empty string or some default value in case of an error
    return '';
  }
}
