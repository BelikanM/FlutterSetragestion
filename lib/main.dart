import 'package:flutter/material.dart';

// 🔹 Importation des écrans
import 'screens/home_screen.dart';
import 'screens/employee_screen.dart';
import 'screens/task_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart'; // ✅ chemin corrigé

// 🔹 Importation du footer commun
import 'footer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Setra Gestion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: const LoginScreen(), // ✅ renommé
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    EmployeeScreen(),
    TaskScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
