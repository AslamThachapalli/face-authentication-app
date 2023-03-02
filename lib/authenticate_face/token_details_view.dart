import 'package:face_auth/constants/theme.dart';
import 'package:face_auth/model/user_model.dart';
import 'package:flutter/material.dart';

class TokenDetailsView extends StatelessWidget {
  final UserModel user;
  const TokenDetailsView({Key? key, required this.user}) : super(key: key);

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: primaryWhite,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: accentColor,
                  child: Icon(
                    Icons.check,
                    color: primaryWhite,
                    size: 44,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Hey ${user.name} !",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                  color: primaryWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Token Redeemed Successfully.",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: primaryWhite.withOpacity(0.6),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 25,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    width: 2,
                    color: primaryWhite,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 25,
                      ),
                      child: Text(
                        "Remaining Tokens",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: primaryWhite,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: accentColor,
                        ),
                        child: Text(
                          "${user.tokensLeft}",
                          style: TextStyle(
                            color: primaryWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
