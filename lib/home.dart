import 'package:flutter/material.dart';
import 'package:projek_akhir/Aktivitas.dart';
import 'package:projek_akhir/konten.dart';
import 'package:projek_akhir/profil.dart';
import 'jadwal.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

import 'lokasi_masjid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebPageUI(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebPageUI extends StatefulWidget {
  const WebPageUI({super.key});

  @override
  State<WebPageUI> createState() => _WebPageUIState();
}

class _WebPageUIState extends State<WebPageUI> {
  String _currentTime = '';
  String _location = 'Menunggu lokasi...';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentTime();
    _startTimer();
    _getLocation();
  }

  // Fungsi untuk mendapatkan waktu real-time
  void _getCurrentTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm:ss');
    setState(() {
      _currentTime = formatter.format(now);
    });
  }

  // Memulai timer untuk memperbarui waktu setiap detik
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getCurrentTime();
    });
  }

  // Fungsi untuk mendapatkan lokasi pengguna dan nama kota
  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = 'Layanan lokasi tidak diaktifkan.';
      });
      return;
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = 'Izin lokasi ditolak.';
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location = 'Izin lokasi ditolak secara permanen.';
      });
      return;
    }

    // Dapatkan posisi pengguna
    final position = await Geolocator.getCurrentPosition();

    // Menggunakan Reverse Geocoding untuk mendapatkan nama kota
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _location = '${place.locality}, ${place.country}';
        });
      } else {
        setState(() {
          _location = 'Lokasi tidak ditemukan.';
        });
      }
    } catch (e) {
      setState(() {
        _location = 'Gagal mendapatkan lokasi: $e';
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _refreshPage() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Tambahkan delay untuk animasi
    _getCurrentTime();
    await _getLocation();
  }

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
                'https://storage.googleapis.com/a1aa/image/KczGlinQs0LsG9YnZMNzQiipVhLCMDx2591aZfNT14B7KR3JA.jpg',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 38),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/Masjid-Nabawi.jpg',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Penjelajah Dakwah',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Waktu: $_currentTime',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'Lokasi: $_location',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.mosque),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LokasiMasjidPage()));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons Section
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity, // Makes the button full-width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DB6AC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        child: const Text('Cari Konten',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DB6AC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const JadwalMaulidPage()));
                        },
                        child: const Text('Jadwal Maulid Nabi',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DB6AC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MapPage()));
                        },
                        child: const Text('Cari Aktivitas Dakwah',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Recommendations Section
                const Text(
                  'Rekomendasi Konten',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://storage.googleapis.com/a1aa/image/ebERGVtJlYw5IavyuGYIcH50UhKJuNA8FqhOER61tsO9KR3JA.jpg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://storage.googleapis.com/a1aa/image/NfCRFWEdjVVxQ6tpmK91edNii52VMV0s0rxXpgrfjZWurEdnA.jpg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
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
                onPressed:
                    _refreshPage, // Mengubah fungsi tombol menjadi refresh halaman
              ),
            ),
          ),
        ),
      ),
    );
  }
}
