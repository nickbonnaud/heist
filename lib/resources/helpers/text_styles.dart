import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class BoldText extends StatelessWidget {
  final double _size;
  final String _text;
  final Color _color;
  final bool _veryBold;

  BoldText({@required String text, @required double size, @required Color color})
    : assert(text != null && size != null && color != null),
      _size = size,
      _text = text,
      _color = color,
      _veryBold = false;

  BoldText.veryBold({@required String text, @required double size, @required Color color, @required bool veryBold})
    : assert(text != null && size != null && color != null && veryBold != null),
      _size = size,
      _text = text,
      _color = color,
      _veryBold = veryBold;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: GoogleFonts.roboto(
        fontWeight: _veryBold ? FontWeight.w900 : FontWeight.w700,
        color: _color,
        fontSize: _size
      )
    );
  }
}

class NormalText extends StatelessWidget {
  final double  _size;
  final String _text;
  final Color _color;

  NormalText({@required String text, @required double size, @required color})
    : assert(size != null && text != null && color != null),
      _size = size,
      _text = text,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w300,
        color: _color,
        fontSize: _size
      )
    );
  }
}