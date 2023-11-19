// translator_view.dart

import 'package:ff/views/quiz_view.dart';
import 'package:flutter/material.dart';
import '../controllers/translator_controller.dart';

import '../models/language_model.dart';
import 'history_view.dart';

class TranslatorView extends StatefulWidget {
  final TranslatorController controller;

  TranslatorView({
    required this.controller,
  });

  @override
  _TranslatorViewState createState() => _TranslatorViewState();
}

class _TranslatorViewState extends State<TranslatorView> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController resultTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Translator',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Icon(Icons.donut_small_sharp),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(
                      recentTranslations: widget.controller.recentTranslations),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.games), // Add the quiz icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizView(
                    controller: widget.controller,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  hint: Text('Select a source language'),
                  value: widget.controller.selectedSourcelanguage.isNotEmpty
                      ? widget.controller.selectedSourcelanguage
                      : null,
                  /* icon: Icon(Icons
                      .arrow_drop_down), // Ajout d'une icône à droite du texte
                  iconSize: 24,*/ // Taille de l'icône
                  elevation: 16, // Élévation de la liste déroulante
                  style: TextStyle(
                    color: Colors.black, // Couleur du texte
                    fontSize: 16.0, // Taille du texte
                  ),
                  underline: Container(
                    height: 2,
                    color:
                        Colors.purple.shade700, // Couleur de la ligne de fond
                  ),
                  onChanged: (String? selectedLanguageCode) {
                    if (selectedLanguageCode != null) {
                      setState(() {
                        widget.controller.selectedSourcelanguage =
                            selectedLanguageCode;
                      });
                    }
                  },
                  items: widget.controller.languages.map((Language language) {
                    return DropdownMenuItem(
                      value: language.code,
                      child: Row(
                        children: [
                          // Icône à gauche du texte
                          //Icon(Icons.language),
                          // SizedBox(width: 8.0),
                          Text(language.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Write your text',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.purple.shade700, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  hint: Text('Select a target language'),
                  value: widget.controller.selectedTargetlanguage.isNotEmpty
                      ? widget.controller.selectedTargetlanguage
                      : null,
                  icon: widget.controller.selectedTargetlanguage.isNotEmpty
                      ? Row(
                          children: [
                            /*Icon(Icons
                                .language), // Icône à gauche de la valeur sélectionnée
                            SizedBox(
                                width:
                                    8.0), */ // Espacement entre l'icône et le texte
                          ],
                        )
                      : null, // Null si aucune valeur n'est sélectionnée
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.purple.shade700,
                  ),
                  onChanged: (String? selectedLanguageCode) {
                    if (selectedLanguageCode != null) {
                      setState(() {
                        widget.controller.selectedTargetlanguage =
                            selectedLanguageCode;
                      });
                    }
                  },
                  items: widget.controller.languages.map((Language language) {
                    return DropdownMenuItem(
                      value: language.code,
                      child: Row(
                        children: [
                          // Icône à gauche du texte
                          SizedBox(width: 8.0),
                          Text(language.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: resultTextEditingController,
                  decoration: InputDecoration(
                    hintText: 'Translation result',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.purple.shade700, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple.shade700,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () async {
                    String sourceLanguage =
                        widget.controller.selectedSourcelanguage;
                    String targetLanguage =
                        widget.controller.selectedTargetlanguage;
                    String textToTranslate = textEditingController.text;

                    if (sourceLanguage.isNotEmpty &&
                        targetLanguage.isNotEmpty &&
                        textToTranslate.isNotEmpty) {
                      await widget.controller.translateText(
                        sourceLanguage,
                        targetLanguage,
                        textToTranslate,
                        resultTextEditingController,
                      );
                      // Update recent translations after performing translation
                      // Update recent translations after performing translation
                      widget.controller.addRecentTranslation(
                        sourceLanguage,
                        textToTranslate,
                        targetLanguage,
                        resultTextEditingController.text,
                      );
                    } else {
                      print(
                          'Please select source and target languages, and enter the text to translate.');
                    }
                  },
                  child: Text(
                    'Translate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
