// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class JadwalDakwahPage extends StatefulWidget {
  const JadwalDakwahPage({super.key});

  @override
  _JadwalDakwahPage createState() => _JadwalDakwahPage();
}

class _JadwalDakwahPage extends State<JadwalDakwahPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> _pinsByDate = {};

  @override
  void initState() {
    super.initState();
  }

  // Cek dan minta izin lokasi
  Future<void> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Izin lokasi ditolak.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Izin lokasi ditolak secara permanen.");
    }
  }

  // Fungsi untuk menampilkan dialog tambah/edit pin
  Future<void> _togglePin(DateTime day, [int? index]) async {
    Map<String, dynamic>? details = await _showPinDetailsDialog(
        day, index != null ? _pinsByDate[day]![index] : null);
    if (details != null && details.isNotEmpty) {
      setState(() {
        DateTime dateKey = DateTime(day.year, day.month, day.day);
        if (_pinsByDate[dateKey] == null) {
          _pinsByDate[dateKey] = [];
        }
        if (index == null) {
          _pinsByDate[dateKey]!.add(details);
        } else {
          _pinsByDate[dateKey]![index] = details;
        }
      });
    }
  }

  // Menampilkan dialog input pin
  Future<Map<String, dynamic>?> _showPinDetailsDialog(
      DateTime day, Map<String, dynamic>? initialData) async {
    TextEditingController namaController =
        TextEditingController(text: initialData?['nama'] ?? '');
    TextEditingController waktuController =
        TextEditingController(text: initialData?['waktu'] ?? '');
    LatLng? selectedLocation = initialData?['lokasi'];

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah/Edit Detil Pengajian"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Pengajian"),
              ),
              TextField(
                controller: waktuController,
                decoration:
                    const InputDecoration(labelText: "Jam (contoh: 18:00 WIB)"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _checkAndRequestLocationPermission();
                  Position currentPosition =
                      await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                  LatLng currentLocation = LatLng(
                      currentPosition.latitude, currentPosition.longitude);

                  // Menampilkan lokasi pengguna di peta
                  LatLng? location =
                      // ignore: use_build_context_synchronously
                      await _pickLocationOnMap(context, currentLocation);
                  if (location != null) {
                    selectedLocation = location;
                  }
                },
                child: const Text("Pilih Lokasi"),
              ),
              if (selectedLocation != null)
                Text(
                    "Lokasi: ${selectedLocation?.latitude}, ${selectedLocation?.longitude}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  "nama": namaController.text,
                  "waktu": waktuController.text,
                  "lokasi": selectedLocation,
                });
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk memilih lokasi di peta
  Future<LatLng?> _pickLocationOnMap(
      BuildContext context, LatLng? initialLocation) async {
    return await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MapPickerPage(initialLocation: initialLocation),
    ));
  }

  // Fungsi untuk menghapus pin
  void _deletePin(DateTime date, int index) {
    setState(() {
      _pinsByDate[date]?.removeAt(index);
      if (_pinsByDate[date]?.isEmpty ?? false) {
        _pinsByDate.remove(date);
      }
    });
  }

  // Membuka Google Maps untuk melihat rute dari lokasi pengguna ke lokasi pin
  void _openRoute(LatLng destination) async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng currentLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);

    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    int selectedMonth = _focusedDay.month;
    int selectedYear = _focusedDay.year;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Jadwal Dakwah"),
      ),
      body: Column(
        children: [
          DropdownButton<int>(
            value: selectedMonth,
            items: List.generate(
              12,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text(months[index]),
              ),
            ),
            onChanged: (value) {
              setState(() {
                selectedMonth = value!;
                _focusedDay = DateTime(selectedYear, selectedMonth, 1);
              });
            },
          ),
          const SizedBox(width: 10),
          DropdownButton<int>(
            value: selectedYear,
            items: List.generate(
              10, // Menampilkan 10 tahun dari 2020 hingga 2030
              (index) => DropdownMenuItem(
                value: 2020 + index,
                child: Text('${2020 + index}'),
              ),
            ),
            onChanged: (value) {
              setState(() {
                selectedYear = value!;
                _focusedDay = DateTime(selectedYear, selectedMonth, 1);
              });
            },
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _togglePin(selectedDay);
            },
            calendarFormat: CalendarFormat.month,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          Expanded(
            child: ListView(
              children: _pinsByDate.entries.map((entry) {
                DateTime date = entry.key;
                String formattedDate =
                    DateFormat('EEEE, dd MMMM yyyy').format(date);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(formattedDate,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ...entry.value.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> pin = entry.value;
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) => _deletePin(date, index),
                        child: ListTile(
                          title: Text("Nama Pengajian: ${pin['nama']}"),
                          subtitle: Text(
                              "Jam: ${pin['waktu']}\nLokasi: ${pin['lokasi']?.latitude}, ${pin['lokasi']?.longitude}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _togglePin(date, index),
                          ),
                          onTap: () {
                            LatLng location = pin['lokasi'];
                            _openRoute(location);
                          },
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPickerPage extends StatelessWidget {
  final LatLng? initialLocation;
  const MapPickerPage({super.key, this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation ?? const LatLng(-6.200000, 106.816666),
          zoom: 14.0,
        ),
        onTap: (location) => Navigator.of(context).pop(location),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
