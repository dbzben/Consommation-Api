// history_view.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  final List<String> recentTranslations;

  HistoryPage({required this.recentTranslations});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Fonction pour vider l'historique
  Future<void> clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('recentTranslations');

    // Mettez à jour la liste des traductions récentes après avoir vidé l'historique
    widget.recentTranslations.clear();
    // Informez le widget de se reconstruire après avoir vidé l'historique
    // en appelant setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation History'),
        backgroundColor: Colors.purple.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              // Appeler la fonction pour vider l'historique
              clearHistory();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.recentTranslations.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.history, color: Colors.purple.shade700),
              title: Text(
                widget.recentTranslations[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Épaisseur de la police
                  color: Colors.black87,
                ),
              ),
              trailing:
                  Icon(Icons.arrow_forward, color: Colors.purple.shade700),
            ),
          );
        },
      ),
    );
  }
}
