import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.title,
    required this.onImage,
  }) : super(key: key);

  final String title;
  final Function(Uint8List inputImage) onImage;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      shrinkWrap: true,
      children: [
        _image != null
            ? SizedBox(
                height: 400,
                width: 400,
                child: Image.file(_image!),
              )
            : Icon(
                Icons.image,
                size: 200,
              ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            child: Text('From Gallery'),
            onPressed: () => _getImage(ImageSource.gallery),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            child: Text('Take a picture'),
            onPressed: () => _getImage(ImageSource.camera),
          ),
        ),
        // if (_image != null)
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Text('${_path == null ? '' : 'Image path: $_path'}'),
        //   ),
      ],
    );
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _setPickedFile(pickedFile);
    }
    setState(() {});
  }

  Future _setPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
    });
    _path = path;

    Uint8List imageBytes = _image!.readAsBytesSync();
    widget.onImage(imageBytes);
  }
}
