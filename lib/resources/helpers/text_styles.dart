import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';

class VeryBoldText1 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText1({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(10)
      ),
    );
  }
}

class VeryBoldText2 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText2({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(9),
      ),
    );
  }
}

class VeryBoldText3 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText3({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(8)
      ),
    );
  }
}

class VeryBoldText4 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText4({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(7)
      ),
    );
  }
}

class VeryBoldText5 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText5({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(6)
      ),
    );
  }
}

class BoldTextCustom extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final double _size;
  final Color? _color;

  const BoldTextCustom({required String text, required BuildContext context, required double size, Color? color})
    : _text = text,
      _context = context,
      _size = size,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: _size
      ),
    );
  }
}

class BoldText1 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText1({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(8)
      ),
    );
  }
}

class BoldText2 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText2({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(7),
      ),
    );
  }
}

class BoldText3 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText3({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(6)
      ),
    );
  }
}

class BoldText4 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText4({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(5)
      ),
    );
  }
}

class BoldText5 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText5({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(4)
      ),
    );
  }
}

class TextCustom extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final double _size;
  final Color? _color;
  
  TextCustom({required String text, required BuildContext context, required double size, Color? color})
    : _text = text,
      _context = context,
      _size = size,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: _size
      ),
    );
  }
}

class Text1 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text1({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(6)
      ),
    );
  }
}

class Text2 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text2({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(5),
      ),
    );
  }
}

class Text3 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text3({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(4)
      ),
    );
  }
}

class Text4 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text4({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(3)
      ),
    );
  }
}

class Text5 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text5({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(2)
      ),
    );
  }
}