import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl, // API bağlantısı için temel URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  /// Kullanıcı giriş yapma
  Future<Response?> login(String email, String password) async {
    try {
      print(" Login API çağrılıyor...");
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: {"email": email, "password": password},
      );

      print(" Login API Yanıtı: ${response.statusCode}");
      print(" API Cevabı: ${response.data}");

      if (response.statusCode == 200 && response.data.containsKey('token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.authTokenKey, response.data['token']);
        return response;
      }
    } catch (e) {
      print(" Login Error: $e");
    }
    return null;
  }

  /// Kullanıcı kayıt işlemi
  Future<Response?> register(String name, String email, String password) async {
    try {
      print(" Register API çağrılıyor...");
      print(" Gönderilen Veriler: Name: $name, Email: $email, Password: $password");

      final response = await _dio.post(
        AppConstants.registerEndpoint,
        data: {"name": name, "email": email, "password": password},
      );

      print(" Register API Yanıtı: ${response.statusCode}");
      print(" API Cevabı: ${response.data}");

      return response;
    } catch (e) {
      print(" Register Error: $e");
    }
    return null;
  }

  /// Kullanıcı profilini getir
  Future<Response?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.authTokenKey);
      if (token == null) return null;

      print(" Kullanıcı profil bilgileri çekiliyor...");
      final response = await _dio.get(
        AppConstants.userProfileEndpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      print(" User Profile Error: $e");
    }
    return null;
  }

  /// **İşletmeleri API'den getir**
  Future<List<dynamic>?> getBusinesses() async {
    try {
      final response = await _dio.get(AppConstants.businessesEndpoint);
      if (response.statusCode == 200) {
        print(" İşletmeler başarıyla alındı!");
        return response.data;
      }
    } catch (e) {
      print(" İşletmeleri getirirken hata oluştu: $e");
    }
    return null;
  }
}