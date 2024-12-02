// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LokasiMasjidPage extends StatefulWidget {
  const LokasiMasjidPage({super.key});

  @override
  _LokasiMasjidPageState createState() => _LokasiMasjidPageState();
}

class _LokasiMasjidPageState extends State<LokasiMasjidPage> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _masjidList = [
    // Jakarta
    {
      "name": "Masjid Istiqlal",
      "address": "Jl. Taman Wijaya Kusuma, Jakarta Pusat",
      "location": const LatLng(-6.170114539528651, 106.83138282845785),
      "city": "Jakarta"
    },
    {
      "name": "Masjid Agung Sunda Kelapa",
      "address": "Jl. Taman Sunda Kelapa, Jakarta Pusat",
      "location": const LatLng(-6.2011582521679705, 106.83215242238575),
      "city": "Jakarta"
    },
    // Jawa Barat
    {
      "name": "Masjid Raya Bandung",
      "address": "Jl. Asia Afrika No.141, Bandung",
      "location": const LatLng(-6.921515191418287, 107.60616196050776),
      "city": "Bandung"
    },
    {
      "name": "Masjid Kubah Emas Dian Al-Mahri Depok",
      "address": "Jl. Meruyung, Depok",
      "location": const LatLng(-6.383679860319752, 106.77195359325351),
      "city": "Depok"
    },
    // Jawa Tengah
    {
      "name": "Masjid Agung Jawa Tengah",
      "address": "Jl. Gajah Raya, Semarang",
      "location": const LatLng(-6.983340896015241, 110.44514051100546),
      "city": "Semarang"
    },
    {
      "name": "Masjid Al-Aqsha Menara Kudus",
      "address": "Jl. Menara, Kudus",
      "location": const LatLng(-6.8041883770333635, 110.83283160589221),
      "city": "Kudus"
    },
    {
      "name": "Masjid Agung Demak",
      "address": "Jl. Sultan Fatah, Demak",
      "location": const LatLng(-6.894626129012306, 110.6372889880005),
      "city": "Demak"
    },
    {
      "name": "Masjid Agung Kraton Surakarta",
      "address": "Jl. Alun-Alun Utara, Surakarta",
      "location": const LatLng(-7.574363306605891, 110.82658724496666),
      "city": "Surakarta"
    },
    {
      "name": "Masjid Jami' Pekalongan",
      "address": "Jl. KH. Wahid Hasyim no.17, Pekalongan",
      "location": const LatLng(-6.889837014992635, 109.67515414744632),
      "city": "Pekalongan"
    },
    // Yogyakarta
    {
      "name": "Masjid Gedhe Keraton Yogyakarta",
      "address": "Jl. Kauman, Yogyakarta",
      "location": const LatLng(-7.803888388030079, 110.3626438122145),
      "city": "Yogyakarta"
    },
    {
      "name": "Masjid Jogokariyan",
      "address": "Jl. Jogokariyan No.36, Yogyakarta",
      "location": const LatLng(-7.824165667368489, 110.36448307594006),
      "city": "Yogyakarta"
    },
    {
      "name": "Masjid Syuhada",
      "address": "Jl. I Dewa Nyoman Oka No.13, Yogyakarta",
      "location": const LatLng(-7.786154724709391, 110.36946971259276),
      "city": "Yogyakarta"
    },
    {
      "name": "Masjid Pathok Negara Plosokuning",
      "address": "Jl. Kaliurang Km 5, Sleman",
      "location": const LatLng(-7.735776876678021, 110.40741903791222),
      "city": "Sleman"
    },
    // Jawa Timur
    {
      "name": "Masjid Al-Akbar Surabaya",
      "address": "Jl. Masjid Al-Akbar No.1, Surabaya",
      "location": const LatLng(-7.3363828332372965, 112.71501610178127),
      "city": "Surabaya"
    },
    {
      "name": "Masjid Agung Sunan Ampel",
      "address": "Jl. Ampel Masjid No.53, Surabaya",
      "location": const LatLng(-7.23031241368973, 112.7429057732771),
      "city": "Surabaya"
    },
    {
      "name": "Masjid Agung Jami' Kota Malang",
      "address": "Jl. Merdeka Barat, Malang",
      "location": const LatLng(-7.982433619927577, 112.62998822796874),
      "city": "Malang"
    },
    {
      "name": "Masjid Tiban Turen",
      "address": "Jl. KH. Wahid Hasyim, Malang",
      "location": const LatLng(-8.150810917823835, 112.71311441597659),
      "city": "Malang"
    },
    {
      "name": "Masjid Muhammad Cheng Hoo Surabaya",
      "address": "Jl. Gading No.2, Surabaya",
      "location": const LatLng(-7.2519287955960055, 112.7468053362609),
      "city": "Surabaya"
    },
    {
      "name": "Masjid Agung Jamik Sumenep",
      "address": "Jl. Trunojoyo No.1, Sumenep",
      "location": const LatLng(-7.008042406215345, 113.85921652278608),
      "city": "Sumenep"
    },
    {
      "name": "Masjid Agung AT TAQWA Bondowoso",
      "address": "Jl. Letnan Sutarman, Bondowoso",
      "location": const LatLng(-7.912664842771565, 113.82093071569143),
      "city": "Bondowoso"
    },
  ];

  List<Map<String, dynamic>> get _filteredMasjidList {
    if (_searchQuery.isEmpty) {
      return _masjidList;
    } else {
      return _masjidList
          .where((masjid) =>
              masjid['city'].toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masjid di Jawa'),
        backgroundColor: const Color(0xFF4DB6AC),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari Kota...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _filteredMasjidList.length,
              itemBuilder: (context, index) {
                final masjid = _filteredMasjidList[index];
                return ListTile(
                  title: Text(masjid['name']),
                  subtitle: Text(masjid['address']),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.newLatLng(masjid['location']),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition != null
                    ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                    : const LatLng(-6.200000, 106.816666),
                zoom: 12.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _filteredMasjidList
                  .map((masjid) => Marker(
                        markerId: MarkerId(masjid['name']),
                        position: masjid['location'],
                        infoWindow: InfoWindow(
                          title: masjid['name'],
                          snippet: masjid['address'],
                        ),
                      ))
                  .toSet(),
            ),
          ),
        ],
      ),
    );
  }
}