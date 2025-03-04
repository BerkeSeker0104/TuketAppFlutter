import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuket_app/providers/auth_provider.dart';
import 'package:tuket_app/core/api_service.dart';
import 'package:tuket_app/screens/business_detail_screen.dart'; //  İşletme detay ekranı eklendi.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _businesses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusinesses();
  }

  Future<void> _fetchBusinesses() async {
    final businesses = await ApiService().getBusinesses();
    if (mounted) {
      setState(() {
        _businesses = businesses ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Profil ekranına yönlendirme (ilerleyen aşamalarda geliştirilecek)
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı Bilgisi
            Text(
              "Hoş geldiniz, ${user?.name ?? 'Kullanıcı'}!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // İşletmeleri Listeleme Başlığı
            const Text(
              "İşletmeler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // İşletmelerin Listelenmesi
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator()) // Yükleniyor animasyonu
                  : _businesses.isEmpty
                  ? const Center(child: Text("Henüz işletme bulunmamaktadır."))
                  : ListView.builder(
                itemCount: _businesses.length,
                itemBuilder: (context, index) {
                  final business = _businesses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.store),
                      title: Text(business["name"]),
                      subtitle: Text(business["address"] ?? "Adres bilgisi yok"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BusinessDetailScreen(businessId: business["id"]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}