import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _placeSuggestions = [];
  final String _googleApiKey = "AIzaSyAbVmKQJKXpj_ScWS82FeeTaNo8loxfJB8"; // Replace with your actual key

  // Function to search for places using Google Places API
  Future<void> searchPlace(String input) async {
    if (input.isEmpty) {
      setState(() => _placeSuggestions = []);
      return;
    }

    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_googleApiKey&types=geocode";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        print(json['predictions']);
        _placeSuggestions = json['predictions'];
      });
    } else {
      throw Exception("Failed to load suggestions");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Location")),
      body: Column(
        children: [
          // Search TextField
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search Location",
          hintStyle: const TextStyle(
            color: Colors.white, // Subtle color for the hint text
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400], // Lighter color for search icon
          ),
          filled: true,
          fillColor: Colors.grey[200], // Light background color for text field
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
            borderSide: BorderSide.none, // No visible border
          ),
        ),
      ),
    ),

          // Display place suggestions
          Expanded(
            child: ListView.builder(
              itemCount: _placeSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _placeSuggestions[index];
                return ListTile(
                  title: Text(suggestion['description']),
                  onTap: () {
                    // Return the selected place data to the first screen
                    Navigator.pop(context, suggestion);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*
// MapBox searchlocation search
class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _placeSuggestions = [];
  final String _mapboxAccessToken = "YOUR_MAPBOX_ACCESS_TOKEN"; // Replace with your actual token

  // Function to search for places using Mapbox Geocoding API
  Future<void> searchPlace(String input) async {
    if (input.isEmpty) {
      setState(() => _placeSuggestions = []);
      return;
    }

    final String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$input.json?access_token=$_mapboxAccessToken&autocomplete=true";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _placeSuggestions = json['features'];
        });
        print("Suggestions: $_placeSuggestions"); // Debugging print
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception("Failed to load suggestions");
      }
    } catch (error) {
      print("Error during search: $error"); // Debugging error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Location")),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => searchPlace(value),
              decoration: InputDecoration(
                hintText: "Search location",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // Display place suggestions
          Expanded(
            child: ListView.builder(
              itemCount: _placeSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _placeSuggestions[index];
                return ListTile(
                  title: Text(suggestion['place_name']),
                  onTap: () {
                    print("Selected location: ${suggestion['place_name']}"); // Debugging print
                    // Return the selected place data to the first screen
                    Navigator.pop(context, suggestion);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

*/
