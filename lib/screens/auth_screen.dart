// Importations
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://10.0.2.2:5000';
  bool _isLoadingLogin = false;
  bool _isLoadingRegister = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------------- LOGIN ----------------
  Future<void> _login() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Tous les champs sont requis');
      return;
    }

    setState(() => _isLoadingLogin = true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/login'),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        await _storage.write(key: 'auth_token', value: data['token']);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        _showSnackBar(data['message'] ?? 'Erreur login');
      }
    } catch (e) {
      _showSnackBar('Erreur: $e');
    } finally {
      if (mounted) setState(() => _isLoadingLogin = false);
    }
  }

  // ---------------- REGISTER ----------------
  Future<void> _register() async {
    final email = _registerEmailController.text.trim();
    final password = _registerPasswordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Tous les champs sont requis');
      return;
    }

    setState(() => _isLoadingRegister = true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/register'),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 && data['success'] == true) {
        // Après inscription, demander OTP
        _showOTPDialog(email);
      } else {
        _showSnackBar(data['message'] ?? 'Échec inscription');
      }
    } catch (e) {
      _showSnackBar('Erreur: $e');
    } finally {
      if (mounted) setState(() => _isLoadingRegister = false);
    }
  }

  // ---------------- OTP ----------------
  void _showOTPDialog(String email) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Vérification OTP'),
        content: TextField(
          controller: otpController,
          decoration: const InputDecoration(labelText: 'Code OTP'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final otp = otpController.text.trim();
              if (otp.isEmpty) return;

              final response = await http.post(
                Uri.parse('$_baseUrl/api/verify-otp'),
                headers: {'Content-Type':'application/json'},
                body: jsonEncode({'email': email, 'otp': otp}),
              );

              final data = jsonDecode(response.body);
              if (response.statusCode == 200 && data['success'] == true) {
                await _storage.write(key: 'auth_token', value: data['token']);
                if (!mounted) return;
                Navigator.pop(context); // fermer OTP dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              } else {
                _showSnackBar(data['message'] ?? 'OTP incorrect');
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentification'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Connexion'),
            Tab(text: 'Inscription'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Login
          SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                TextField(controller: _loginEmailController, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 16),
                TextField(controller: _loginPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe')),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoadingLogin ? null : _login,
                  child: _isLoadingLogin ? const CircularProgressIndicator(color: Colors.white) : const Text('Se connecter'),
                ),
              ],
            ),
          ),
          // Register
          SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                TextField(controller: _registerEmailController, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 16),
                TextField(controller: _registerPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe')),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoadingRegister ? null : _register,
                  child: _isLoadingRegister ? const CircularProgressIndicator(color: Colors.white) : const Text('S\'inscrire'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
