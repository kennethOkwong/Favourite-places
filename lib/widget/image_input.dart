import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onPickImage,
  });

  final Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  //Function to pick image
  File? selectedImage;
  void pickImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.camera);

    if (image == null) {
      return;
    }

    setState(() {
      selectedImage = File(image.path);
    });

    widget.onPickImage(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      height: 200,
      width: double.infinity,
      alignment: Alignment.center,
      child: selectedImage == null
          ? TextButton.icon(
              onPressed: () => pickImage(),
              icon: const Icon(Icons.camera),
              label: const Text('Take a photo'),
            )
          : GestureDetector(
              onTap: () => pickImage(),
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
    );
  }
}
