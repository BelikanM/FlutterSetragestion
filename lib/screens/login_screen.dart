import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main.dart'; // chemin relatif vers MainScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://10.0.2.2:5000';

  bool _isLoadingLogin = false;
  bool _isLoadingRegister = false;

  bool _obscureLogin = true;
  bool _obscureRegister = true;

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
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['token'] != null) {
          await _storage.write(key: 'auth_token', value: data['token']);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        } else {
          _showSnackBar(data['message'] ?? 'Utilisateur non reconnu');
          _tabController.animateTo(1);
        }
      } else {
        final data = jsonDecode(response.body);
        _showSnackBar(data['message'] ?? 'Erreur serveur');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Erreur: $e');
    } finally {
      if (mounted) setState(() => _isLoadingLogin = false);
    }
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar('Inscription réussie. Vérifiez votre email pour l’OTP.');
        setState(() {
          _registerEmailController.clear();
          _registerPasswordController.clear();
        });
        _tabController.animateTo(0);

        // Afficher popup OTP
        _showOtpDialog(email);
      } else {
        final data = jsonDecode(response.body);
        _showSnackBar(data['message'] ?? 'Échec de l\'inscription');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Erreur: $e');
    } finally {
      if (mounted) setState(() => _isLoadingRegister = false);
    }
  }

  Future<void> _showOtpDialog(String email) async {
    final otpController = TextEditingController();

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Vérification OTP'),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Entrez votre code OTP'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final otp = otpController.text.trim();
              if (otp.isEmpty) {
                _showSnackBar('Veuillez entrer le code OTP');
                return;
              }

              try {
                final response = await http.post(
                  Uri.parse('$_baseUrl/api/verify-otp'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'email': email, 'otp': otp}),
                );

                final data = jsonDecode(response.body);

                if (response.statusCode == 200 && data['success'] == true) {
                  await _storage.write(key: 'auth_token', value: data['token']);
                  if (!mounted) return;
                  Navigator.of(context).pop(); // fermer le popup
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                  );
                } else {
                  _showSnackBar(data['message'] ?? 'OTP incorrect');
                }
              } catch (e) {
                _showSnackBar('Erreur: $e');
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          TextField(
            controller: _loginEmailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _loginPasswordController,
            obscureText: _obscureLogin,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureLogin ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _obscureLogin = !_obscureLogin);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoadingLogin ? null : _login,
            child: _isLoadingLogin
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Se connecter'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          TextField(
            controller: _registerEmailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _registerPasswordController,
            obscureText: _obscureRegister,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureRegister ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _obscureRegister = !_obscureRegister);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoadingRegister ? null : _register,
            child: _isLoadingRegister
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('S\'inscrire'),
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
          _buildLoginTab(),
          _buildRegisterTab(),
        ],
      ),
    );
  }
}
