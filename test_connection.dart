import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const baseUrl = 'http://10.0.2.2:5000';

  try {
    final response = await http.get(Uri.parse('$baseUrl/employees'));
    if (response.statusCode == 200) {
      print('✅ Connexion réussie : ${response.body}');
    } else {
      print('❌ Erreur serveur : ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('❌ Erreur connexion : $e');
  }
}
