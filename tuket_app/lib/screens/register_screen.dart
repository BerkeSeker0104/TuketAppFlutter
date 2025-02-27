import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuket_app/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    print("📢 _register metodu çalışıyor...");

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool isRegistered = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    print(" _register metodu tamamlandı!");

    if (isRegistered) {
      print(" Kayıt başarılı! Ana ekrana yönlendiriliyor...");
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print(" Kullanıcı kayıt olamadı!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarısız! Lütfen bilgilerinizi kontrol edin.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Ad Soyad"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "E-posta"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Şifre"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(" Kayıt ol butonuna tıklandı!");
                _register(); //  _register metodunu çağır
              },
              child: const Text("Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}