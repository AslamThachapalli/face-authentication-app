import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EnterDetailsView extends StatefulWidget {
  final String image;

  const EnterDetailsView({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<EnterDetailsView> createState() => _EnterDetailsViewState();
}

class _EnterDetailsViewState extends State<EnterDetailsView> {
  bool isRegistering = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _organizationIdController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _noOfTokensController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Details"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      buildTextFormField(
                        controller: _nameController,
                        hintText: "Name",
                      ),
                      buildTextFormField(
                        controller: _organizationIdController,
                        hintText: "Organization Id",
                      ),
                      buildTextFormField(
                        controller: _designationController,
                        hintText: "Designation",
                      ),
                      buildTextFormField(
                        controller: _noOfTokensController,
                        hintText: "Number of tokens",
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isRegistering = true;
                      });

                      String userId = Uuid().v1();
                      UserModel user = UserModel(
                        id: userId,
                        name: _nameController.text.trim().toUpperCase(),
                        image: widget.image,
                        organizationId: _organizationIdController.text,
                        designation: _designationController.text,
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                        tokensLeft:
                            int.parse(_noOfTokensController.text.trim()),
                        lastRedeemedOn: null,
                      );

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(userId)
                          .set(user.toJson())
                          .catchError((e) {
                        log("Registration Error: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Registration Failed! Try Again."),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                        setState(() {
                          isRegistering = false;
                        });
                      }).whenComplete(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Registration Success!"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        setState(() {
                          isRegistering = false;
                        });
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        });
                      });
                    }
                  },
                  child: isRegistering
                      ? Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Text("Register".toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(
      {required TextEditingController controller,
      required String hintText,
      TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
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
      },
    );
  }
}
