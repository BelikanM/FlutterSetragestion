import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyses & Statistiques"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tableau d'Analyses",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildStatCard("Employés Actifs", "128", Colors.blue),
                  _buildStatCard("Tâches Terminées", "340", Colors.green),
                  _buildStatCard("Projets", "12", Colors.orange),
                  _buildStatCard("Retards", "5", Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: color.withValues(alpha: 0.15),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
