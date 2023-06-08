import 'package:favourite_places/credentials.dart';
import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/screens/map.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  get getMapImage {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${place.location.lat},${place.location.lng}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${place.location.lat},${place.location.lng}&key=$googleMapAPIKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black54,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return MapScreen(
                            location: place.location,
                            isSelecting: false,
                          );
                        },
                      ));
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                        getMapImage,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
