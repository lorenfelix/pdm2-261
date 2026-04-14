// temperature_server.dart
import 'dart:io';

void main() async {
  print('🌡️  Servidor de Temperatura iniciado...');
  print('👂 Aguardando conexões na porta 8080...');
  
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 8080);
  print('✅ Servidor rodando em ${server.address.address}:${server.port}');
  
  server.listen((Socket client) {
    handleClient(client);
  });
  
  print('⏳ Servidor pronto para receber dados IoT...\n');
}

void handleClient(Socket client) {
  final clientAddress = client.remoteAddress.address;
  final clientPort = client.remotePort;
  print('🔗 Nova conexão de $clientAddress:$clientPort');
  
  // Buffer para ler linhas completas
  final List<int> buffer = [];
  
  client.listen(
    (List<int> data) {
      buffer.addAll(data);
      _processBuffer(buffer, client);
    },
    onError: (error) {
      print('❌ Erro no cliente $clientAddress:$clientPort - $error');
      client.destroy();
    },
    onDone: () {
      print('👋 Cliente $clientAddress:$clientPort desconectado');
      client.destroy();
    },
  );
}

void _processBuffer(List<int> buffer, Socket client) {
  final separator = '\n'.codeUnitAt(0);
  
  for (int i = 0; i < buffer.length; i++) {
    if (buffer[i] == separator) {
      final line = String.fromCharCodes(buffer.sublist(0, i));
      buffer.removeRange(0, i + 1);
      
      if (line.startsWith('TEMP:')) {
        final tempStr = line.substring(5); // Remove "TEMP:"
        final temp = double.tryParse(tempStr.replaceAll('°C', '')) ?? 0.0;
        
        print('🌡️  [$DateTime.now().toString().substring(11, 19)] '
              'IoT ${client.remoteAddress.address}: '
              '$tempStr (valor: ${temp.toStringAsFixed(2)})');
      }
      
      // Processa próxima linha se houver dados restantes
      if (buffer.isNotEmpty) {
        _processBuffer(buffer, client);
      }
      break;
    }
  }
}
