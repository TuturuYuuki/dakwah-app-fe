// main.dart
import 'package:flutter/material.dart';
import 'package:projek_akhir/pendakwah/aktivitas_dakwah.dart';
import 'package:projek_akhir/pendakwah/jadwal_dakwah.dart';
import 'package:projek_akhir/pendakwah/konten_dakwah.dart';
import 'package:projek_akhir/pendakwah/home_dakwah.dart';

import 'login.dart';
import 'signup.dart';
import 'home.dart';
import 'konten.dart';
import 'jadwal.dart';
import 'aktivitas.dart';
import 'reset_password.dart';
import 'lokasi_masjid.dart';
import 'profil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const WebPageUI(),
        '/konten': (context) => const HomePage(),
        '/jadwal': (context) => const JadwalMaulidPage(),
        '/aktivitas': (context) => const MapPage(),
        '/reset_password': (context) => const PasswordResetPage(),
        '/lokasi_masjid': (context) => const LokasiMasjidPage(),
        '/profil': (context) => const ProfilePage(),
        '/home_dakwah': (context) => const HomeDakwahPage(),
        '/konten_dakwah': (context) => const KontenDakwahPage(),
        '/jadwal_dakwah': (context) => const JadwalDakwahPage(),
        '/aktivitas_dakwah': (context) => const AktivitasDakwahPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
