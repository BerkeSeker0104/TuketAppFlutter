import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Kullanıcıdan fotoğraf seç ve Firebase Storage'a yükle
  Future<String?> uploadImage() async {
    try {
      //  Kullanıcıdan fotoğraf seçmesini iste
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return null;

      File file = File(pickedFile.path);
      String fileName = basename(file.path);

      //  Firebase Storage'a yükleme işlemi
      Reference ref = _storage.ref().child("product_images/$fileName");
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(" Hata: $e");
      return null;
    }
  }
}