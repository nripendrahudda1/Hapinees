/*
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class LocationSearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final String apiKey = 'ksjdhskdhskhdshsd'; // Replace with your API Key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Places Search")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(
              textEditingController: _controller,
              googleAPIKey: apiKey,
              inputDecoration: const InputDecoration(
                hintText: "Search location...",
                border: OutlineInputBorder(),
              ),
              debounceTime: 400,
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (place) {
                // print("Selected Place: ${place["description"]}");
                // print("Latitude: ${place["lat"]}, Longitude: ${place["lng"]}");
              },
              itemClick: (place) {
                _controller.text = place.description ?? "";
              },
              seperatedBuilder: const Divider(),
              containerVerticalPadding: 10,
            ),
          ],
        ),
      ),
    );
  }
}
*/
