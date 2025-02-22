import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:5124/api/Users'),
  );

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return response.data;
      }
      return null;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        "name": name,
        "email": email,
        "password": password,
      });

      return response.statusCode == 200;
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}