import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/foundation.dart';

class SocketService {
  late io.Socket socket;

  /// Connecte le client Socket.IO au serveur
  /// [serverUrl] doit être l'URL complète du backend
  void connect(String serverUrl) {
    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) => debugPrint('✅ Connecté au Socket.IO'));
    socket.onDisconnect((_) => debugPrint('❌ Déconnecté du Socket.IO'));
    socket.on('message', (data) => debugPrint('Message reçu: $data'));
  }

  /// Envoie un message au serveur
  void sendMessage(String message) {
    socket.emit('message', message);
  }

  /// Déconnecte le client
  void disconnect() {
    socket.disconnect();
  }
}
