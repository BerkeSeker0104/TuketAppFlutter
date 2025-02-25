import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  /// Kullanıcı giriş işlemi
  Future<void> login(String email, String password) async {
    final response = await ApiService().login(email, password);
    if (response != null && response.data is Map<String, dynamic>) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", response.data["token"]);

      await loadUserProfile();
      notifyListeners();
    }
  }

  /// Kullanıcı kayıt işlemi
  Future<bool> register(String name, String email, String password) async {
    print("📢 Register metodu çağrıldı");

    final response = await ApiService().register(name, email, password);

    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
      print(" Kullanıcı başarıyla kaydedildi!");

      // Kullanıcı başarılı şekilde kayıt olduysa giriş işlemi yap
      await login(email, password);

      // Kullanıcı giriş yaptıysa, authenticated olarak işaretle
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token != null) {
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    }

    print(" Kayıt başarısız! API Yanıtı: ${response?.data}");
    return false;
  }

  /// Kullanıcı profilini yükle
  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token == null) {
      _isAuthenticated = false;
      notifyListeners();
      return;
    }

    final response = await ApiService().getUserProfile();
    if (response != null && response.data is Map<String, dynamic>) {
      _user = UserModel.fromJson(response.data);
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  /// Kullanıcı oturumunu kontrol et (Uygulama açıldığında çağrılır)
  Future<void> checkAuthStatus() async {
    print("🔍 Kullanıcı oturum durumu kontrol ediliyor...");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token != null) {
      await loadUserProfile();
      print(" Kullanıcı oturum açık.");
    } else {
      _isAuthenticated = false;
      print(" Kullanıcı oturumu kapalı.");
    }
    notifyListeners();
  }

  /// Kullanıcı çıkış işlemi
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
    _user = null;
    _isAuthenticated = false;
    notifyListeners();

    // Kullanıcıyı giriş ekranına yönlendir
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}