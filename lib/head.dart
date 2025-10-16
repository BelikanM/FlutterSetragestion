import 'package:flutter/material.dart';
import 'headerscreen/notification_page.dart';
import 'headerscreen/profile_page.dart';

class Head extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Head({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Vérifie si le Scaffold a un drawer
    final hasDrawer = Scaffold.maybeOf(context)?.hasDrawer ?? false;

    return AppBar(
      elevation: 3,
      backgroundColor: Colors.green.shade700,
      leading: hasDrawer
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null, // Pas de menu si pas de drawer
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
