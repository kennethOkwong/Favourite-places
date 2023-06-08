import 'dart:developer';

import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.location,
    required this.isSelecting,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PlaceLocation? pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick a location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  pickedLocation = PlaceLocation(
                      lat: position.latitude,
                      lng: position.longitude,
                      address: '');
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.lat,
            widget.location.lng,
          ),
          zoom: 16,
        ),
        markers: {
          Marker(
              markerId: const MarkerId('m1'),
              position: pickedLocation != null
                  ? LatLng(pickedLocation!.lat, pickedLocation!.lng)
                  : LatLng(
                      widget.location.lat,
                      widget.location.lng,
                    )),
        },
      ),
    );
  }
}
