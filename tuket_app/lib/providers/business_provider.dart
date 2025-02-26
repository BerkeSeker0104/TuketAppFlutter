import 'package:flutter/material.dart';
import '../core/api_service.dart';

class BusinessProvider with ChangeNotifier {
  List<dynamic> _businesses = [];

  List<dynamic> get businesses => _businesses;

  Future<void> fetchBusinesses() async {
    final response = await ApiService().getBusinesses();
    if (response != null) {
      _businesses = response;
      notifyListeners(); // Değişiklikleri dinleyerek UI’yi güncelle
    }
  }
}