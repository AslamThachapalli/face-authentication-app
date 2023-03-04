import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/authenticate_face/token_details_view.dart';
import 'package:face_auth/common/utils/extract_face_feature.dart';
import 'package:face_auth/common/views/camera_view.dart';
import 'package:face_auth/common/views/custom_button.dart';
import 'package:face_auth/constants/theme.dart';
import 'package:face_auth/model/date_model.dart';
import 'package:face_auth/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class AuthenticateFaceView extends StatefulWidget {
  const AuthenticateFaceView({Key? key}) : super(key: key);

  @override
  State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
}

class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  FaceFeatures? _faceFeatures;
  var image1 = Regula.MatchFacesImage();
  var image2 = Regula.MatchFacesImage();

  String _similarity = "";
  bool _canAuthenticate = false;
  // final _formKey = GlobalKey<FormFieldState>();
  // final TextEditingController _nameController = TextEditingController();
  List<dynamic> users = [];
  bool userExists = false;
  UserModel? loggingUser;
  bool isMatching = false;

  @override
  void initState() {
    super.initState();

    _initPlatformState();
  }

  Future<void> _initPlatformState() async {}

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: Text("Authenticate Face"),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constrains) => Stack(
          children: [
            Container(
              width: constrains.maxWidth,
              height: constrains.maxHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scaffoldTopGradientClr,
                    scaffoldBottomGradientClr,
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.82,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      decoration: BoxDecoration(
                        color: Color(0xff2E2E2E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          CameraView(
                            onImage: (image) {
                              _setImage(image);
                            },
                            onInputImage: (inputImage) async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: accentColor,
                                  ),
                                ),
                              );
                              _faceFeatures = await extractFaceFeatures(
                                  inputImage, _faceDetector);
                              setState(() {});
                              if (mounted) Navigator.of(context).pop();
                            },
                          ),
                          Spacer(),
                          if (_canAuthenticate)
                            CustomButton(
                              text: "Redeem Token",
                              arrowColor: primaryBlack,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                      color: accentColor,
                                    ),
                                  ),
                                );

                                FirebaseFirestore.instance
                                    .collection("users")
                                    .get()
                                    .catchError((e) {
                                  log("Getting User Error: $e");
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Something went wrong. Please try again."),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ),
                                  );
                                }).then((snap) {
                                  if (snap.docs.isNotEmpty) {
                                    users.clear();
                                    log(snap.docs.length.toString(),
                                        name: "Total Registered Users");
                                    for (var doc in snap.docs) {
                                      UserModel user =
                                          UserModel.fromJson(doc.data());
                                      double similarity = compareFaces(
                                          _faceFeatures!, user.faceFeatures!);
                                      if (similarity >= 0.8 &&
                                          similarity <= 2) {
                                        users.add([user, similarity]);
                                      }
                                    }
                                    log(users.length.toString(),
                                        name: "Filtered Users");
                                    setState(() {
                                      users.sort((a, b) =>
                                          (((a.last as double) - 1).abs())
                                              .compareTo(
                                                  ((b.last as double) - 1)
                                                      .abs()));
                                    });

                                    _matchFaces();
                                  } else {
                                    _showDialog(
                                      title: "No Users Registered",
                                      description:
                                          "Make sure users are registered first before redeeming token.",
                                    );
                                  }
                                });
                              },
                            ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _setImage(Uint8List imageToAuthenticate) async {
    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = Regula.ImageType.PRINTED;

    setState(() {
      _canAuthenticate = true;
    });
  }

  double compareFaces(FaceFeatures face1, FaceFeatures face2) {
    double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
    double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);

    double ratioEar = distEar1 / distEar2;

    double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
    double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);

    double ratioEye = distEye1 / distEye2;

    double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
    double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);

    double ratioCheek = distCheek1 / distCheek2;

    double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
    double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);

    double ratioMouth = distMouth1 / distMouth2;

    double distNoseToMouth1 =
        euclideanDistance(face1.noseBase!, face1.bottomMouth!);
    double distNoseToMouth2 =
        euclideanDistance(face2.noseBase!, face2.bottomMouth!);

    double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;

    double ratio =
        (ratioEye + ratioEar + ratioCheek + ratioMouth + ratioNoseToMouth) / 5;
    log("------Ratio--------");
    log(ratio.toString());

    return ratio;
  }

// A function to calculate the Euclidean distance between two points
  double euclideanDistance(Points p1, Points p2) {
    final sqr =
        math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }

  _matchFaces() async {
    bool faceMatched = false;
    for (List user in users) {
      image1.bitmap = (user.first as UserModel).image;
      image1.imageType = Regula.ImageType.PRINTED;

      //Face comparing logic.
      var request = Regula.MatchFacesRequest();
      request.images = [image1, image2];
      dynamic value = await Regula.FaceSDK.matchFaces(jsonEncode(request));

      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      dynamic str = await Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75);

      var split =
          Regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
      setState(() {
        _similarity = split!.matchedFaces.isNotEmpty
            ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
            : "error";
        log("similarity: $_similarity");

        if (_similarity != "error" && double.parse(_similarity) > 90.00) {
          faceMatched = true;
          loggingUser = user.first;
        } else {
          faceMatched = false;
        }
      });
      if (faceMatched) {
        _redeemToken();
        break;
      }
    }
    if (!faceMatched) {
      _showDialog(
        title: "Redeem Failed",
        description: "Face doesn't match. Please try again.",
      );
    }
  }

  _redeemToken() {
    int? tokenLastUsedOn;
    if (loggingUser!.lastRedeemedOn != null) {
      DateTime now = DateTime.now();
      DateTime lastRedeemed = DateTime.fromMillisecondsSinceEpoch(
        loggingUser!.lastRedeemedOn!,
      );
      tokenLastUsedOn =
          DateTime(lastRedeemed.year, lastRedeemed.month, lastRedeemed.day)
              .difference(
                DateTime(now.year, now.month, now.day),
              )
              .inDays;
    }

    if (loggingUser!.lastRedeemedOn == null || tokenLastUsedOn! != 0) {
      if (loggingUser!.tokensLeft! != 0) {
        setState(() {
          int tokens = loggingUser!.tokensLeft! - 1;
          loggingUser!.tokensLeft = tokens;

          int redeemedOn = DateTime.now().millisecondsSinceEpoch;
          loggingUser!.lastRedeemedOn = redeemedOn;

          int tokensUsed = loggingUser!.tokensUsed! + 1;
          loggingUser!.tokensUsed = tokensUsed;
        });
        FirebaseFirestore.instance
            .collection("users")
            .doc(loggingUser!.id!)
            .update(
              loggingUser!.toJson(),
            )
            .catchError((e) {
          log("Error updating redeemed date: $e");
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Something went wrong. Please try again."),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }).whenComplete(
          () {
            DateTime now = DateTime.now();
            int today =
                DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
            FirebaseFirestore.instance
                .collection("date")
                .doc(today.toString())
                .get()
                .then((snap) {
              DateModel? date;
              if (snap.exists) {
                date = DateModel.fromJson(snap.data()!);
                date.tokenUsersId!.add(loggingUser!.id!);
              } else {
                date = DateModel(
                  date: today,
                  tokenUsersId: [loggingUser!.id!],
                );
              }
              FirebaseFirestore.instance
                  .collection("date")
                  .doc(today.toString())
                  .set(
                    date.toJson(),
                  );
            });

            Navigator.of(context)
              ..pop()
              ..push(
                MaterialPageRoute(
                  builder: (context) => TokenDetailsView(user: loggingUser!),
                ),
              );
          },
        );
      } else {
        _showDialog(
          title: "No Token Left",
          description: "You have used all available tokens",
        );
      }
    } else {
      _showDialog(
        title: "Token Used",
        description: "You have already redeemed today's token!",
      );
    }
  }

  _showDialog({
    required String title,
    required String description,
  }) {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    color: accentColor,
                  ),
                ),
              )
            ],
          );
        });
  }
}
