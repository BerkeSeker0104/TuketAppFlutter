import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuket_app/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();

    Future.delayed(const Duration(seconds: 2), () {
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tuket_logo.png', //  Splash ekranına logo eklendi
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // Yükleme animasyonu
          ],
        ),
      ),
    );
  }
}