import 'package:flutter/material.dart';

class ScreenSizeUtil {
  /// init in the MaterialApp
  static late BuildContext context;

  static get screenWidth => MediaQuery.of(context).size.width;

  static get screenHeight => MediaQuery.of(context).size.height;
}
