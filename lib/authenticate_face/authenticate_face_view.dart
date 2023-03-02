import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/authenticate_face/token_details_view.dart';
import 'package:face_auth/common/views/camera_view.dart';
import 'package:face_auth/common/views/custom_button.dart';
import 'package:face_auth/constants/theme.dart';
import 'package:face_auth/model/date_model.dart';
import 'package:face_auth/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:flutter/material.dart';

class AuthenticateFaceView extends StatefulWidget {
  const AuthenticateFaceView({Key? key}) : super(key: key);

  @override
  State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
}

class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
  var image1 = Regula.MatchFacesImage();
  var image2 = Regula.MatchFacesImage();

  String _similarity = "";
  bool _canAuthenticate = false;
  final _formKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();
  List<UserModel> users = <UserModel>[];
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CameraView(
                              onImage: (image) {
                                _setImage(image);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: TextFormField(
                                key: _formKey,
                                controller: _nameController,
                                style: const TextStyle(
                                  color: primaryWhite,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.6,
                                ),
                                cursorColor: Color(0xffAAAAAA),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xff484848),
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                    color: primaryWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Color(0xffAAAAAA),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Color(0xffAAAAAA),
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return "Enter Name";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            if (_canAuthenticate)
                              CustomButton(
                                text: "Redeem Token",
                                arrowColor: primaryBlack,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();

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
                                        .where(
                                          "name",
                                          isEqualTo: _nameController.text
                                              .trim()
                                              .toUpperCase(),
                                        )
                                        .get()
                                        .catchError((e) {
                                      log("Getting User Error: $e");
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                        setState(() {
                                          for (var doc in snap.docs) {
                                            users.add(
                                              UserModel.fromJson(doc.data()),
                                            );
                                          }
                                        });

                                        _matchFaces();
                                      } else {
                                        _showDialog(
                                          title: "User Not Found",
                                          description:
                                              "Make sure user is registered. If already registered enter registered name.",
                                        );
                                      }
                                    });
                                  }
                                },
                              ),
                            SizedBox(height: 30),
                          ],
                        ),
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

  _matchFaces() async {
    bool faceMatched = false;
    for (UserModel user in users) {
      image1.bitmap = user.image;
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
          loggingUser = user;
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
          // loggingUser!.redeemedDates!.add(redeemedOn);

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
