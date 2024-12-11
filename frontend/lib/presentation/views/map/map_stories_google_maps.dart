import 'package:flutter/material.dart';

class MapStoriesGoogleMaps extends StatefulWidget {
  const MapStoriesGoogleMaps({super.key});

  @override
  State<MapStoriesGoogleMaps> createState() => _MapStoriesGoogleMapsState();
}

class _MapStoriesGoogleMapsState extends State<MapStoriesGoogleMaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("Google Maps - Ubicación y Marcadores")));
  }
}