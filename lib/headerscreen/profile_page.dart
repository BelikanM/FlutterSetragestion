import 'package:flutter/material.dart';
import '../head.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Head(title: 'Profil utilisateur'),
      body: Center(
        child: Text(
          'Page du profil utilisateur.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
