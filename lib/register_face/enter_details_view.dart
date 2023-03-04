import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/common/views/custom_button.dart';
import 'package:face_auth/constants/theme.dart';
import 'package:face_auth/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EnterDetailsView extends StatefulWidget {
  final String image;
  final FaceFeatures faceFeatures;
  const EnterDetailsView({
    Key? key,
    required this.image,
    required this.faceFeatures,
  }) : super(key: key);

  @override
  State<EnterDetailsView> createState() => _EnterDetailsViewState();
}

class _EnterDetailsViewState extends State<EnterDetailsView> {
  bool isRegistering = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _organizationIdController =
      TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _noOfTokensController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Add Details"),
        elevation: 0,
      ),
      body: Container(
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
        child: LayoutBuilder(
          builder: (context, constrains) => SizedBox(
            height: constrains.maxHeight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: constrains.maxHeight * 0.18),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildTextFormField(
                            _nameController,
                            "Name",
                          ),
                          buildTextFormField(
                            _organizationIdController,
                            "Organisation ID",
                          ),
                          buildTextFormField(
                            _designationController,
                            "Designation",
                          ),
                          buildTextFormField(
                            _noOfTokensController,
                            "No. of Tokens",
                            TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: constrains.maxHeight * 0.28),
                  CustomButton(
                    text: "Register Now",
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

                        String userId = Uuid().v1();
                        UserModel user = UserModel(
                          id: userId,
                          name: _nameController.text.trim().toUpperCase(),
                          image: widget.image,
                          organizationId: _organizationIdController.text,
                          designation: _designationController.text,
                          registeredOn: DateTime.now().millisecondsSinceEpoch,
                          tokensLeft:
                              int.parse(_noOfTokensController.text.trim()),
                          lastRedeemedOn: null,
                          faceFeatures: widget.faceFeatures,
                        );

                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
                            .set(user.toJson())
                            .catchError((e) {
                          log("Registration Error: $e");
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Registration Failed! Try Again."),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );
                        }).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Registration Success!"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: accentColor,
                            ),
                          );
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pop();
                          });
                        });
                      }
                    },
                  ),
                  SizedBox(height: constrains.maxHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTextFormField(
    TextEditingController controller,
    String hintText, [
    TextInputType? keyboardType,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
          controller: controller,
          cursorColor: primaryBlack.withOpacity(0.8),
          style: const TextStyle(
            color: primaryBlack,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
          ),
          decoration: InputDecoration(
            hintText: hintText,
          ),
          keyboardType: keyboardType,
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "Field cannot be empty";
            } else {
              return null;
            }
          }),
    );
  }
}
