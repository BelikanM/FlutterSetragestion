import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails des Employés"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Liste des employés récents",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Exemple de carte employé
            Expanded(
              child: ListView(
                children: List.generate(
                  6,
                  (index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person, color: Colors.blue.shade700),
                      ),
                      title: Text("Employé ${index + 1}"),
                      subtitle: const Text("Poste : Développeur Flutter"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
