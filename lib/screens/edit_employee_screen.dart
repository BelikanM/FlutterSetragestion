import 'package:flutter/material.dart';

class EditEmployeeScreen extends StatelessWidget {
  const EditEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier un employé')),
      body: const Center(
        child: Text('Formulaire pour modifier un employé'),
      ),
    );
  }
}
