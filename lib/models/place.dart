import 'dart:io';

class Place {
  final String id;
  final String name;
  final File image;
  final PlaceLocation location;

  const Place({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
  });
}

class PlaceLocation {
  final double lat;
  final double lng;
  final String address;

  const PlaceLocation({
    required this.lat,
    required this.lng,
    required this.address,
  });
}
