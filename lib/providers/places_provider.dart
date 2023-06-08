import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favourite_places/models/place.dart';

class PlacesStateNotifier extends StateNotifier<List<Place>> {
  PlacesStateNotifier() : super([]);

  void addPlace(Place place) {
    state = [place, ...state];
  }
}

final placesProvider = StateNotifierProvider<PlacesStateNotifier, List<Place>>(
  (ref) => PlacesStateNotifier(),
);
