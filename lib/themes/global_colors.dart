import 'package:flutter/material.dart';

extension GlobalColors on ColorScheme {
  Color get success => Colors.greenAccent[400]!;
  Color get successDisabled => Colors.greenAccent[100]!;
  Color get info => Colors.lightBlueAccent[400]!;
  Color get infoDisabled => Colors.lightBlueAccent[100]!;
  Color get warning => Colors.orangeAccent[400]!;
  Color get warningDisabled => Colors.orangeAccent[100]!;
  Color get danger => Colors.red;
  Color get dangerDisabled => Colors.red[300]!;


  Color get draggableBar => Colors.grey;
  
  Color get primarySubdued => Colors.grey[300]!;
  Color get secondarySubdued => Colors.grey[600]!;

  Color get onPrimarySubdued => Colors.black54;
  Color get onPrimaryDisabled => Colors.black26;

  Color get onSecondarySubdued => Colors.white70;
  Color get onSecondaryDisabled => Colors.white54;

  Color get topAppBar => Colors.white10;
  Color get topAppBarIcon => Color(0xFF016fb9);

  Color get scrollBackground => Colors.grey.shade100;

  Color get keyboardHelpBarLight => Colors.grey[100]!;

  Color get iconPrimary => Colors.white;
  Color get iconSecondary => Colors.grey[800]!;
  Color get iconButton => Colors.white;

  Color get callToAction => Color(0xFF016fb9);
  Color get callToActionDisabled => Color(0xFFcce2f1);
  Color get onCallToAction => Colors.white;

}