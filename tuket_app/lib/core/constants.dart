// Bu dosyada API URL’leri, token saklama anahtarları gibi değişmez verileri tutacağız.

class AppConstants {
  static const String baseUrl = "http://127.0.0.1:5214/api"; // Backend URL'i
  static const String loginEndpoint = "$baseUrl/Users/login";
  static const String registerEndpoint = "$baseUrl/Users/register";
  static const String userProfileEndpoint = "$baseUrl/Users/me";
  static const String businessesEndpoint = "$baseUrl/Businesses"; //isletmeler icin api endpoint'i
  static const String authTokenKey = "auth_token"; // JWT Token için saklama anahtarı
}