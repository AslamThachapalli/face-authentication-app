import 'package:face_auth/constants/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? arrowColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.arrowColor = const Color(0xffFFFFFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: primaryBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.double_arrow_sharp,
                  color: arrowColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
