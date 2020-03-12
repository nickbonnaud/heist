import 'package:flutter/material.dart';

ThemeData defaultTheme = ThemeData(
  // brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.orange,
  cursorColor: Colors.orange,
  // fontFamily: 'SourceSansPro',
  textTheme: TextTheme(
    display2: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 45.0,
      // fontWeight: FontWeight.w400,
      color: Colors.orange,
    ),
    button: TextStyle(
      // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
      fontFamily: 'OpenSans',
    ),
    caption: TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.deepPurple[300],
    ),
    display4: TextStyle(fontFamily: 'Quicksand'),
    display3: TextStyle(fontFamily: 'Quicksand'),
    display1: TextStyle(fontFamily: 'Quicksand'),
    headline: TextStyle(fontFamily: 'NotoSans'),
    title: TextStyle(fontFamily: 'NotoSans'),
    subhead: TextStyle(fontFamily: 'NotoSans'),
    body2: TextStyle(fontFamily: 'NotoSans'),
    body1: TextStyle(fontFamily: 'NotoSans'),
    subtitle: TextStyle(fontFamily: 'NotoSans'),
    overline: TextStyle(fontFamily: 'NotoSans'),
  )
);