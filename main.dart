import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  Position? _currentPosition;
  String? _currentAddress;
  bool _showLocationDetails = false;

  Future<bool> _handlePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Permission Denied");
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        debugPrint("Permission Denied! Change Settings");
        return false;
      }
    }
    return true;
  }

  _getCurrentLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      _addressFromCoordinates(_currentPosition!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _addressFromCoordinates(Position position) async {
    List<Placemark> places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final place = places[0];
    setState(() {
      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Show Location Details'),
                    Switch(
                      value: _showLocationDetails,
                      onChanged: (value) {
                        setState(() {
                          _showLocationDetails = value;
                        });
                      },
                    ),
                  ],
                ),
                if (_showLocationDetails)
                  Column(
                    children: [
                      Text(
                          'LAT: ${_currentPosition?.latitude ?? "No position defined"}'),
                      Text('LNG: ${_currentPosition?.longitude ?? ""}'),
                      Text('ADDRESS: ${_currentAddress ?? ""}'),
                    ],
                  ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: _getCurrentLocation,
                  child: const Text("Get Current Location"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
