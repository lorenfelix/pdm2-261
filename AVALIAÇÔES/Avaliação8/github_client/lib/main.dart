import 'package:flutter/material.dart';
import 'package:github/github.dart';

import 'github_oauth_credentials.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "Não logado";

  Future<void> loginGithub() async {
    final gitHub = GitHub();

    try {
      final user = await gitHub.users.getCurrentUser();

      setState(() {
        username = user.login ?? "Sem nome";
      });
    } catch (e) {
      setState(() {
        username = "Erro ao conectar";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GitHub Client"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              username,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginGithub,
              child: const Text("Login GitHub"),
            )
          ],
        ),
      ),
    );
  }
}