import 'package:flutter/material.dart';
import '../head.dart'; // Chemin correct vers ton Head.dart

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Head(title: 'Notifications'),
      body: Center(
        child: Text(
          'Aucune notification disponible.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
