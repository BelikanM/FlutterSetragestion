import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapports & Documents"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rapports récents",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
                  _buildReportCard("Rapport de Performance", "12 Octobre 2025"),
                  _buildReportCard("Analyse Financière", "10 Octobre 2025"),
                  _buildReportCard("Rapport des Ressources", "05 Octobre 2025"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(String title, String date) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.picture_as_pdf, color: Colors.teal.shade400),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Date : $date"),
        trailing: const Icon(Icons.download),
        onTap: () {},
      ),
    );
  }
}
