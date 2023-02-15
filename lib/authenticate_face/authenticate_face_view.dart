import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:face_auth/common/camera_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateFaceView extends StatefulWidget {
  const AuthenticateFaceView({Key? key}) : super(key: key);

  @override
  State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
}

class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
  var image1 = new Regula.MatchFacesImage();
  var image2 = new Regula.MatchFacesImage();
  String _similarity = "nil";
  bool _canAuthenticate = false;
  String? _userName;

  @override
  void initState() {
    super.initState();

    _initPlatformState();
  }

  Future<void> _initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: CameraView(
              title: "Authenticate Face",
              onImage: (image) {
                _setImage(context, image);
              },
            ),
          ),
          if (_canAuthenticate)
            SizedBox(
              width: 250,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black12),
                ),
                onPressed: () {
                  _matchFaces();
                },
                child: Text("Authenticate"),
              ),
            ),
          SizedBox(height: 15),
          if (_similarity != 'nil')
            Text(
              "Similarity: ${_similarity}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          SizedBox(height: 10),
          if (_userName != null)
            Text(
              "Hi: ${_userName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future _setImage(BuildContext context, Uint8List imageToAuthenticate) async {
    setState(() => _similarity = "nil");
    final pref = await SharedPreferences.getInstance();

    String? registeredFace = pref.getString('image');

    if (registeredFace == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No Faces Registered. Register a face first."),
      ));
      setState(() {
        _canAuthenticate = false;
      });
      return;
    }

    image1.bitmap = registeredFace;
    image1.imageType = Regula.ImageType.PRINTED;

    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = Regula.ImageType.PRINTED;

    setState(() {
      _canAuthenticate = true;
    });
  }

  _matchFaces() async {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") return;
    setState(() => _similarity = "Processing...");
    final pref = await SharedPreferences.getInstance();
    var request = new Regula.MatchFacesRequest();
    request.images = [image1, image2];
    Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
              jsonEncode(response!.results), 0.75)
          .then((str) {
        var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
            json.decode(str));
        setState(() {
          _similarity = split!.matchedFaces.length > 0
              ? ((split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2) +
                  "%")
              : "error";
          log(_similarity);
          if (_similarity != "error") {
            _userName = pref.getString('name');
          } else {
            _userName = "Couldn't Recognize Face :(";
          }
        });
      });
    });
  }
}
