import 'package:face_auth/model/user_model.dart';
import 'package:flutter/material.dart';

class TokenDetailsView extends StatelessWidget {
  final UserModel user;
  const TokenDetailsView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Token Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hi, ${user.name}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Token Redeemed Successfully.",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            Text(
              "Remaining Tokens: ${user.tokensLeft}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
