
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Imagepicker extends StatefulWidget {
  const Imagepicker(this.PickedImage, {Key? key}) : super(key: key);

  final void Function(File Image) PickedImage;

  @override
  State<Imagepicker> createState() => _ImagepickerState();
}

class _ImagepickerState extends State<Imagepicker> {
   File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _imagePicker() async {
    final ImageFile = await _picker.pickImage(source: ImageSource.camera, maxWidth: 150, imageQuality: 50);

    setState(() {
      _pickedImage = File(ImageFile!.path);

    });
    Navigator.of(context).pop();
    widget.PickedImage(File(ImageFile!.path));
  }

  void _imagePicker2() async {
    final ImageFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 150, imageQuality: 50);
    setState(() {
      _pickedImage = File(ImageFile!.path);

    });
    Navigator.of(context).pop();
    widget.PickedImage(File(ImageFile!.path));
  }

  void choosePic() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'Pick Image From',
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.w500),
              ),
            ),
            content: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: _imagePicker,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.teal,
                            size: 35,
                          )),
                      const Text(
                        'Camera',
                        style: TextStyle(color: Colors.teal),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: _imagePicker2,
                          icon:const  Icon(
                            Icons.image_outlined,
                            color: Colors.teal,
                            size: 35,
                          )),
                     const Text(
                        'Gallery',
                        style: TextStyle(color: Colors.teal),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: _pickedImage == null
              ? AssetImage('Assets/Images/profilepic.jpg') as ImageProvider
              : FileImage(File(_pickedImage!.path)),
        ),
        TextButton.icon(
            onPressed: choosePic,
            icon: Icon(Icons.photo_camera_back_outlined),
            label: Text('Add Profile Pic')),
      ],
    );
  }
}
