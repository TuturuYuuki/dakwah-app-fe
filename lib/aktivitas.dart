import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-7.257472, 112.752090);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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