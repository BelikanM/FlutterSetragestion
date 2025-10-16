import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green.shade700,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Employés'),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tâches'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
      ],
    );
  }
}
