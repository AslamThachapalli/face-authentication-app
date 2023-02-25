import 'dart:convert';

import 'package:face_auth/common/camera_view.dart';
import 'package:face_auth/register_face/enter_details_view.dart';
import 'package:flutter/material.dart';

class RegisterFaceView extends StatefulWidget {
  RegisterFaceView({Key? key}) : super(key: key);

  @override
  State<RegisterFaceView> createState() => _RegisterFaceViewState();
}

class _RegisterFaceViewState extends State<RegisterFaceView> {
  String? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: CameraView(
              title: "Register Face",
              onImage: (image) {
                setState(() {
                  _image = base64Encode(image);
                });
              },
            ),
          ),
          if (_image != null)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff4ab4de),
                        ),
                      ),
                      child: Text('Start Registering'.toUpperCase()),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EnterDetailsView(
                              image: _image!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
