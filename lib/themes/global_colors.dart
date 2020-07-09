import 'package:flutter/material.dart';

extension GlobalColors on ColorScheme {
  Color get success => Colors.greenAccent[400];
  Color get successDisabled => Colors.greenAccent[100];
  Color get info => Colors.lightBlueAccent[400];
  Color get infoDisabled => Colors.lightBlueAccent[100];
  Color get warning => Colors.orangeAccent[400];
  Color get warningDisabled => Colors.orangeAccent[100];
  Color get danger => Colors.red;
  Color get dangerDisabled => Colors.red[300];

  Color get textOnLight => Colors.black;
  Color get textOnLightSubdued => Colors.black54;
  Color get textOnLightDisabled => Colors.black26;
  
  Color get textOnDark => Colors.white;
  Color get textOnDarkSubdued => Colors.white70;
  Color get clickable => Colors.blue;

  Color get buttonOutlineCancel => Colors.black;
  Color get buttonOutlineCancelDisabled => Colors.grey.shade500;

  Color get topAppBarLight => Colors.white10;
  Color get topAppBarIconLight => Colors.black;

  Color get scrollBackgroundLight => Colors.grey.shade100;

  Color get keyboardHelpBarOnDark => Colors.white24;

  Color get iconPrimary => Colors.green;
  Color get iconSecondary => Colors.orange;

  Color get primarySubdued => Colors.green[100];
  Color get secondarySubdued => Colors.orange[100];
}