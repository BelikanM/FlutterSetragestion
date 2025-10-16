import 'package:flutter/material.dart';
import '../head.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Head(title: 'Employés'),
      body: const Center(
        child: Text(
          'Liste des employés',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
