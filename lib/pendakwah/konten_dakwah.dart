import 'package:flutter/material.dart';

void main() {
  runApp(const KontenDakwahApp());
}

class KontenDakwahApp extends StatelessWidget {
  const KontenDakwahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Page Conversion',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const KontenDakwahPage(),
    );
  }
}

Future<void> _refreshPage() async {
  // Tambahkan delay agar animasi terlihat lebih halus
  await Future.delayed(const Duration(seconds: 1));
}

class KontenDakwahPage extends StatelessWidget {
  const KontenDakwahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4DB6AC),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://storage.googleapis.com/a1aa/image/7dnAVsQFnWIjCF2Nuv5wiGCp36be9A9NQQsd49He12CciyuTA.jpg',
              ),
              radius: 17,
            ),
             SizedBox(width: 8),
            Flexible(
              child: Text(
                "Zulkilpi Siregar",
                overflow: TextOverflow.ellipsis,
                ),
              ),
              
          ],
        ),
        actions: const [
          Icon(Icons.account_circle, size: 38),
        ],
      ),
      body: RefreshIndicator(
  onRefresh: _refreshPage,
  child: Column(
    children: [
      // Search Bar
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF4DB6AC),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Row(
            children: [
              Icon(Icons.menu, color: Colors.black),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Konten',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Icon(Icons.search, color: Colors.black),
            ],
          ),
        ),
      ),
      // Content Grid
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          physics: const AlwaysScrollableScrollPhysics(), // Memungkinkan pull-to-refresh
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://storage.googleapis.com/a1aa/image/scsYjwgGR1YxFddsm541pqEZTCxjwD2pxNE2gzeohptNRZ3JA.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                if (index % 2 == 0)
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ],
  ),
),

// Footer
      bottomNavigationBar: Container(
        height: 70, // Sesuaikan tinggi sesuai kebutuhan
        color: const Color(0xFFF4A300), // Warna penuh
        child: Center(
            child: Container(
              width: 50,
              height: 50,
            decoration: const BoxDecoration(
          color: Color(0xFF3A8B7D),
        shape: BoxShape.circle,
        ),
         child: Center(
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 35),
              onPressed: () {
                Navigator.pop(context); // Navigasi kembali ke halaman sebelumnya
              },
            ),
          ),
         ),
        ),
      ),


    );
  }
}
