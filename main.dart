import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController _mapController;

  _handleTap(LatLng point) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          onTap: (argument) {
            _handleTap(argument);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.4279, -122.0888),
            zoom: 12,
          ),
          markers: {
            const Marker(
              markerId: MarkerId("20SW031"),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(37.4279, -122.0888),
              infoWindow: InfoWindow(title: "20SW031"),
            )
          },
        ),
      ),
    );
  }
}
