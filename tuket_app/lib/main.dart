import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuket_app/providers/auth_provider.dart';
import 'package:tuket_app/screens/login_screen.dart';
import 'package:tuket_app/screens/register_screen.dart';
import 'package:tuket_app/screens/home_screen.dart';
import 'package:tuket_app/screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
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
      title: 'Tüket',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', //  Splash Screen başlangıç ekranı olarak ayarlandı
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}