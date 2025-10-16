import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_screen.dart'; // <- remplace login_screen.dart si AuthScreen est ton écran principal

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Déconnexion réussie')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Déconnexion'),
      content: const Text('Souhaitez-vous vraiment vous déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('Se déconnecter'),
        ),
      ],
    );
  }
}
