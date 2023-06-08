import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/widget/image_input.dart';
import 'package:favourite_places/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerWidget {
  const AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    File? selectedImage;
    PlaceLocation? selectedLocation;

    //Function to set image property
    void _setImage(File image) {
      selectedImage = image;
    }

    //Function to add a place
    void addPlace() {
      if (selectedImage == null || selectedLocation == null) {
        return;
      }
      if (formKey.currentState!.validate()) {
        ref.read(placesProvider.notifier).addPlace(
              Place(
                id: DateTime.now().toString(),
                name: name,
                image: selectedImage!,
                location: selectedLocation!,
              ),
            );
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1) {
                    return 'Invalid Input';
                  }
                  name = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              ImageInput(
                onPickImage: (image) => _setImage(image),
              ),
              const SizedBox(
                height: 5,
              ),
              LocationInput(
                onSelectedLocation: (location) {
                  selectedLocation = location;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  addPlace();
                },
                label: const Text('Add Place'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
