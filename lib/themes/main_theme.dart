import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/themes/global_colors.dart';

class MainTheme {
  static Color topAppBar = Colors.white10;


  static Color _primary = Colors.white;
  static Color _primaryVariant = Colors.grey[300]!;
  static Color _constrastPrimary = Colors.black;

  static Color _secondary = Colors.grey[800]!;
  static Color _secondaryVariant = Colors.black;
  static Color _constrastSecondary = Colors.white;

  static ThemeData themeData({required BuildContext context}) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: _primary
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Theme.of(context).colorScheme.callToActionDisabled;
            }
            return Theme.of(context).colorScheme.callToAction;
          }),
          elevation: MaterialStateProperty.resolveWith<double>((states) => states.contains(MaterialState.pressed) || states.contains(MaterialState.disabled) ? 0 : 2)
        )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return _primaryVariant;
            }
            return null;
          }),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(color: Theme.of(context).colorScheme.callToActionDisabled);
            }
            return BorderSide(color: Theme.of(context).colorScheme.callToAction);
          }),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF016fb9)
      ),
      appBarTheme: AppBarTheme(
        textTheme: _getTextTheme(context: context)
      ),

      colorScheme: ColorScheme(
        primary: _primary, 
        primaryVariant: _primaryVariant,
        onPrimary: _constrastPrimary,

        secondary: _secondary,
        secondaryVariant: _secondaryVariant, 
        onSecondary: _constrastSecondary, 

        surface: Colors.grey,
        onSurface: Colors.black,
        background: _primary,
        onBackground: _constrastPrimary, 

        error: Colors.red,  
        onError: Colors.white, 
        brightness: Brightness.light,
      ),
      textTheme: _getTextTheme(context: context),
      buttonColor: Color(0xFF016fb9),
      disabledColor: Color(0xFFcce2f1),
    );
  }

  static TextTheme _getTextTheme({required BuildContext context}) {
    return GoogleFonts.racingSansOneTextTheme(Theme.of(context).textTheme);
  }

  static TextStyle getDefaultFont() {
    return GoogleFonts.racingSansOne();
  }
}