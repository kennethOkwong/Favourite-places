import 'package:favourite_places/widget/places_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/screens/add_place.dart';
import 'package:favourite_places/screens/place_details.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Place> places = [];
  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);

// Logic to choose body content
    Widget body;
    if (places.isEmpty) {
      body = Center(
        child: Text(
          'No data yet... try adding a place',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    } else {
      body = ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return PlaceDetailsScreen(place: places[index]);
                    },
                  ),
                );
              },
              child: ListItem(place: places[index]));
        },
      );
    }
    // //Scaffold Widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddPlaceScreen(),
              ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: body,
    );
  }
}
