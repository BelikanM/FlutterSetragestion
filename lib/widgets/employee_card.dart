import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String position;
  final double salary;

  const EmployeeCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.person, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(position, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            Text('\$${salary.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
