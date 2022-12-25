import 'package:flutter/material.dart';

class DimensionsCustom {
  static double widthScreen =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double heightScreen =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

  static double calculateWidth(double width) {
    return widthScreen / 100 * width;
  }

  static double calculateHeight(double height) {
    return heightScreen / 100 * height;
  }
}
