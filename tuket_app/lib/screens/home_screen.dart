import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuket_app/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout(context); // ✅ context parametresi eklendi!
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Hoş geldiniz!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}