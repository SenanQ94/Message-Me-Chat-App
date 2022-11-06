import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File? pickedImage) imagePickFn;

  const UserImagePicker({super.key, required this.imagePickFn});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  void _options() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _pickImage('camera'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Color(0xff0B6EF1),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff0B6EF1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _pickImage('gallery'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_rounded,
                        size: 30,
                        color: Color(0xff0B6EF1),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff0B6EF1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  void _pickImage(String btnSource) async {
    final userImage = await _picker.pickImage(
      source: btnSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (userImage != null) {
      setState(() {
        pickedImage = File(userImage.path);
      });
    }
    widget.imagePickFn(pickedImage);
  }

  ImageProvider _getImageWidget() {
    if (pickedImage != null) {
      return FileImage(pickedImage!);
    }
    return AssetImage('images/user_placeholder.png');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: _getImageWidget(),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  mini: true,
                  onPressed: _options,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
