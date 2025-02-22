import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuket_app/providers/auth_provider.dart' as auth;
import 'package:tuket_app/screens/login_screen.dart';
import 'package:tuket_app/screens/register_screen.dart';
import 'package:tuket_app/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => auth.AuthProvider()), // ✅ Çakışma giderildi
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tüket App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),  // Başlangıç ekranı
        '/register': (context) => const RegisterScreen(),  // **Kayıt ol ekranı**
        '/home': (context) => const HomeScreen(), // **Ana ekran**
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}