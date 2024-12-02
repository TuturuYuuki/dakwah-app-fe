import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AktivitasDakwahPage extends StatefulWidget {
  const AktivitasDakwahPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AktivitasDakwahPageState createState() => _AktivitasDakwahPageState();
}

class _AktivitasDakwahPageState extends State<AktivitasDakwahPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-7.257472, 112.752090);
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng position, String title) {
    final String markerId = 'marker_${_markers.length}';
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      );
    });
  }

  Future<void> _showAddMarkerDialog(LatLng position) async {
    String markerTitle = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Penanda'),
          content: TextField(
            onChanged: (value) {
              markerTitle = value;
            },
            decoration: const InputDecoration(hintText: 'Masukkan nama penanda'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addMarker(position, markerTitle);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
        onTap: (position) {
          _showAddMarkerDialog(position);
        },
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFFF4A300),
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
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}