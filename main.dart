import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiFunctionScreen(),
    );
  }
}

class MultiFunctionScreen extends StatefulWidget {
  @override
  _MultiFunctionScreenState createState() => _MultiFunctionScreenState();
}

class _MultiFunctionScreenState extends State<MultiFunctionScreen> {
  String cityName = "";
  String weatherData = "";
  List<Map<String, String>> _photoData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Function App'),
      ),
      body: Column(
        children: [
          // Weather App
          const SizedBox(
            height: 10,
          ),
          const Text("Fetching Weather Data",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Enter City Name'),
                  onChanged: (value) {
                    setState(() {
                      cityName = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchWeatherData();
                  },
                  child: Text('Get Weather'),
                ),
                SizedBox(height: 20),
                Text(weatherData),
              ],
            ),
          ),
          // Photo Viewer
          const Text("Fetching Image Data From JSON-Place-Holder",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: Unable to fetch photo data'));
                } else {
                  return ListView.builder(
                    itemCount: _photoData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading:
                            Image.network(_photoData[index]['thumbnailUrl']!),
                        title: Text(_photoData[index]['title']!),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchWeatherData() async {
    final apiKey = 'e6ceee8fa704f2698c55c294d93a6b86';
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temperature = (data['main']['temp'] - 273.15).toStringAsFixed(1);
      final description = data['weather'][0]['description'];
      setState(() {
        weatherData = 'Temperature: $temperature°C\nDescription: $description';
      });
    } else {
      setState(() {
        weatherData = 'Error: Unable to fetch weather data';
      });
    }
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var item in jsonData) {
        _photoData.add({
          'thumbnailUrl': item['thumbnailUrl'],
          'title': item['title'],
        });
      }
    } else {
      throw Exception('Unable to fetch photo data');
    }
  }
}
