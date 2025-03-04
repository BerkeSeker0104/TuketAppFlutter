import 'package:flutter/material.dart';
import 'package:tuket_app/services/storage_service.dart';
import 'package:tuket_app/core/api_service.dart';

class BusinessDetailScreen extends StatefulWidget {
  final int businessId; // İşletme ID'si alacak

  const BusinessDetailScreen({super.key, required this.businessId});

  @override
  _BusinessDetailScreenState createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService(); //  ApiService burada tanımlandı!
  String? imageUrl;

  ///  **Fotoğraf Yükleme İşlemi**
  void _uploadImage() async {
    String? uploadedUrl = await _storageService.uploadImage();
    if (uploadedUrl != null) {
      setState(() {
        imageUrl = uploadedUrl;
      });
      print(" Fotoğraf Yüklendi: $uploadedUrl");
    } else {
      print(" Fotoğraf yüklenemedi.");
    }
  }

  ///  **API’ye Ürün Kaydetme İşlemi**
  void _saveProduct() async {
    if (imageUrl == null) {
      print(" Lütfen önce bir fotoğraf yükleyin.");
      return;
    }

    bool success = await _apiService.addProduct(
      name: "Örnek Ürün",
      description: "Bu bir örnek açıklamadır.",
      price: 50.0,
      businessId: widget.businessId,
      imageUrl: imageUrl!,
    );

    if (success) {
      print(" Ürün başarıyla eklendi.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ürün başarıyla eklendi!")),
      );
    } else {
      print(" Ürün eklenirken hata oluştu.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ürün eklenemedi!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İşletme Detayı")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //  **Fotoğraf Önizlemesi**
            imageUrl != null
                ? Image.network(imageUrl!, height: 200)
                : const Icon(Icons.image, size: 100, color: Colors.grey),

            const SizedBox(height: 20),

            //  **Fotoğraf Yükleme Butonu**
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text("Ürün Fotoğrafı Yükle"),
            ),

            const SizedBox(height: 10),

            //  **Ürün Kaydet Butonu**
            ElevatedButton(
              onPressed: _saveProduct,
              child: const Text("Ürünü API'ye Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}