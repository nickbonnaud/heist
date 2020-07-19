import 'package:heist/resources/helpers/size_config.dart';

class SharedSizes {
  final double startSize = SizeConfig.getWidth(12);
  final double endSize = SizeConfig.getWidth(22);
  
  final double startMarginTop = SizeConfig.getHeight(1);
  final double endMarginTop = SizeConfig.getHeight(1);
  
  final double verticalSpacing = SizeConfig.getHeight(4);
  final double horizontalSpacing = SizeConfig.getWidth(4);

  final double minLogoRightBorderRadius = SizeConfig.getWidth(2);
}