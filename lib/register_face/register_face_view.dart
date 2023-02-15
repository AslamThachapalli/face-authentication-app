import 'dart:convert';
import 'dart:typed_data';

import 'package:face_auth/common/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterFaceView extends StatefulWidget {
  RegisterFaceView({Key? key}) : super(key: key);

  @override
  State<RegisterFaceView> createState() => _RegisterFaceViewState();
}

class _RegisterFaceViewState extends State<RegisterFaceView> {
  TextEditingController _textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraView(
            title: "Register Face",
            onImage: (image) {
              if (_formKey.currentState!.validate()) {
                _saveToSharedPreference(
                    context, image, _textEditingController.text);
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: TextFormField(
                key: _formKey,
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: "Enter Your Name",
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please enter a name and try again";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _saveToSharedPreference(
    BuildContext context,
    Uint8List image,
    String name,
  ) async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();

    await pref.setString("name", name);

    String bytesToString = base64Encode(image);
    await pref.setString("image", bytesToString);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Face Registered Successfully")),
    );
  }
}
