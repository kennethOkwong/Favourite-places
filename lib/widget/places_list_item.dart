import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: FileImage(place.image)),
      title: Text(
        place.name,
      ),
      subtitle: Text(
        place.location.address,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
