import 'package:flutter/widgets.dart';

@immutable
class SizeConfig {
  static double? _blockSizeHorizontal;
  static double? _blockSizeVertical;

  void init(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    final double screenHeight = mediaQueryData.size.height;
    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;
  }

  static double getHeight(double heightPercent) {
    return _blockSizeVertical! * heightPercent;
  }

  static double getWidth(double widthPercent) {
    return _blockSizeHorizontal! * widthPercent;
  }
}