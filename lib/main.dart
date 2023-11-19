// main.dart
import 'package:flutter/material.dart';
import '../controllers/translator_controller.dart';
import '../views/translator_view.dart';

void main() async {
  TranslatorController controller = TranslatorController();
  WidgetsFlutterBinding.ensureInitialized();

  await controller.fetchLanguages();
  await controller.loadRecentTranslations();

  runApp(MyApp(
    controller: controller,
  ));
}

class MyApp extends StatelessWidget {
  final TranslatorController controller;

  MyApp({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Translator App',
      home: TranslatorView(controller: controller),
      debugShowCheckedModeBanner: false,
    );
  }
}
