// iot_device.dart
import 'dart:io';
import 'dart:math';
import 'dart:async';

void main() async {
  print('🚀 IoT Device - Sensor de Temperatura iniciado...');
  print('📡 Tentando conectar ao servidor...');
  
  // Configuração do servidor
  final serverHost = InternetAddress.loopbackIPv4;
  final serverPort = 8080;
  
  Socket? socket;
  bool connected = false;
  
  // Função para conectar ao servidor
  Future<void> connectToServer() async {
    try {
      socket = await Socket.connect(serverHost, serverPort);
      connected = true;
      print('✅ Conectado ao servidor em ${serverHost.address}:$serverPort');
    } catch (e) {
      print('❌ Falha na conexão: $e');
      connected = false;
    }
  }
  
  // Gerador de temperatura simulada (15-35°C)
  double generateTemperature() {
    final random = Random();
    return 15 + random.nextDouble() * 20; // 15 a 35°C
  }
  
  // Função para enviar temperatura
  Future<void> sendTemperature(double temp) async {
    if (!connected || socket == null) {
      print('⚠️  Não conectado ao servidor');
      return;
    }
    
    try {
      final message = 'TEMP:${temp.toStringAsFixed(2)}°C';
      socket!.write('$message\n');
      print('📤 Enviado: $message');
    } catch (e) {
      print('❌ Erro ao enviar: $e');
      connected = false;
    }
  }
  
  
  // Loop principal - tenta conectar e envia a cada 10s
  Timer.periodic(Duration(seconds: 10), (timer) async {
    if (!connected) {
      await connectToServer();
    } else {
      final temp = generateTemperature();
      await sendTemperature(temp);
    }
  });
  
  // Reconexão automática a cada 30s se desconectado
  Timer.periodic(Duration(seconds: 30), (timer) async {
    if (!connected) {
      print('🔄 Tentando reconectar...');
      await connectToServer();
    }
  });
  
  // Listener para desconexão
  socket?.listen(
    (data) => print('📨 Recebido do servidor: ${String.fromCharCodes(data)}'),
    onError: (error) {
      print('❌ Erro na conexão: $error');
      connected = false;
    },
    onDone: () {
      print('🔌 Conexão fechada pelo servidor');
      connected = false;
    },
  );
}