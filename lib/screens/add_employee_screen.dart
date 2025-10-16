import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un employé')),
      body: const Center(
        child: Text('Formulaire pour ajouter un employé'),
      ),
    );
  }
}
