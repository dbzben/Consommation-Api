import 'package:flutter/material.dart';
import '../controllers/translator_controller.dart';
import '../models/language_model.dart';

class QuizView extends StatefulWidget {
  final TranslatorController controller;

  QuizView({required this.controller});

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  List<Word> words = [];
  int score = 0;
  String selectedSourceLanguage = '';
  Map<int, TextEditingController> textEditingControllers = {};

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    List<Word> fetchedWords = await widget.controller.fetchWords();
    setState(() {
      words = fetchedWords;
      textEditingControllers.clear(); // Clear existing controllers
      for (int i = 0; i < words.length; i++) {
        textEditingControllers[i] = TextEditingController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Icon(Icons.help),
          ],
        ),
        actions: [
          // Add any actions you want in the app bar here
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Translate from French to:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10), // Add spacing
                DropdownButton<String>(
                  hint: Text('Select a source language'),
                  value: selectedSourceLanguage.isNotEmpty
                      ? selectedSourceLanguage
                      : null,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  underline: Container(),
                  onChanged: (String? selectedLanguageCode) {
                    if (selectedLanguageCode != null) {
                      setState(() {
                        selectedSourceLanguage = selectedLanguageCode;
                      });
                    }
                  },
                  items: widget.controller.languages.map((Language language) {
                    return DropdownMenuItem(
                      value: language.code,
                      child: Row(
                        children: [
                          Text(language.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        words[index].name,
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 200,
                              ),
                              child: TextField(
                                controller: textEditingControllers[index],
                                decoration: InputDecoration(
                                  hintText: 'Enter translation here',
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.purple.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () async {
                              String translatedText = await widget.controller
                                  .translateeText(
                                      'fr',
                                      selectedSourceLanguage,
                                      (textEditingControllers[index]?.text)
                                          .toString());
                              print(translatedText);

                              if (translatedText.toLowerCase() ==
                                  words[index].name) {
                                setState(() {
                                  score++;
                                  print(score);
                                });
                              }

                              textEditingControllers[index]?.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Refresh the quiz
                    setState(() {
                      score = 0;
                    });
                    loadWords();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh '),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple.shade700,
                    elevation: 5,
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Quiz Result'),
                          content: Text('Score: $score/${words.length}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple.shade700,
                    elevation: 5,
                  ),
                  child: Text('Validate', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
