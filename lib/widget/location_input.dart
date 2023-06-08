import 'dart:convert';
import 'dart:developer';

import 'package:favourite_places/credentials.dart';
import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectedLocation,
  });

  final Function(PlaceLocation location) onSelectedLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool isGettingLocation = false;
  bool mapIsAvailable = false;
  late PlaceLocation? placeLocation;

  get getMapImage {
    if (placeLocation == null || placeLocation == null) {
      return;
    }
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${placeLocation!.lat},${placeLocation!.lng}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${placeLocation!.lat},${placeLocation!.lng}&key=$googleMapAPIKey';
  }

  void get getCurrentLocation async {
    final Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    String address = '';

    if (lat == null || lng == null) {
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapAPIKey');

    final response = await http.get(url);
    final resData = json.decode(response.body);

    if (response.statusCode >= 400) {
      return;
    } else {
      address = resData['results'][0]['formatted_address'];
    }

    setState(() {
      placeLocation = PlaceLocation(
        lat: lat,
        lng: lng,
        address: address,
      );
      isGettingLocation = false;
      mapIsAvailable = true;
    });
    widget.onSelectedLocation(placeLocation!);
  }

  //Function to navigate and choose location on map

  _pickOnMap() async {
    final Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }
    final pickedLocation = await Navigator.of(context).push<PlaceLocation>(
      MaterialPageRoute(
        builder: (context) {
          return MapScreen(
              location: PlaceLocation(
                  lat: locationData.latitude!,
                  lng: locationData.longitude!,
                  address: ''),
              isSelecting: true);
        },
      ),
    );
    if (pickedLocation == null) {
      return;
    }
    setState(() {
      placeLocation = pickedLocation;
    });
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${pickedLocation.lat},${pickedLocation.lng}&key=$googleMapAPIKey');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    String address = '';

    if (response.statusCode >= 400) {
      return;
    } else {
      address = resData['results'][0]['formatted_address'];
    }

    setState(() {
      placeLocation = PlaceLocation(
        lat: pickedLocation.lat,
        lng: pickedLocation.lng,
        address: address,
      );
      isGettingLocation = false;
      mapIsAvailable = true;
    });
    widget.onSelectedLocation(placeLocation!);
  }

// code to choose widget body

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location chosen',
      style: Theme.of(context).textTheme.bodyLarge,
    );
    if (isGettingLocation) {
      content = const CircularProgressIndicator();
    }

    if (mapIsAvailable) {
      content = Image.network(getMapImage);
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all()),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: content,
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Load current location'),
            ),
            TextButton.icon(
              onPressed: () {
                _pickOnMap();
              },
              icon: const Icon(Icons.map),
              label: const Text('Pick on map'),
            )
          ],
        )
      ],
    );
  }
}
