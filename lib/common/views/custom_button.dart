import 'package:face_auth/common/utils/extensions/size_extension.dart';
import 'package:face_auth/constants/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.05.sw),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(0.02.sh),
        ),
        child: Padding(
          padding: EdgeInsets.all(0.03.sw),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.03.sw),
                child: Text(
                  text,
                  style: TextStyle(
                    color: primaryBlack,
                    fontSize: 0.025.sh,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 0.03.sh,
                backgroundColor: accentColor,
                child: const Icon(
                  Icons.arrow_circle_right,
                  color: buttonColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
