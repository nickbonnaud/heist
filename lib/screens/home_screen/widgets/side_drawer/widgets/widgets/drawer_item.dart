import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

class DrawerItem extends StatelessWidget {
  final VoidCallback _onPressed;
  final String _text;
  final Widget _icon;

  const DrawerItem({@required onPressed, @required text, @required icon})
    : assert(onPressed != null && text != null && icon != null),
      _onPressed = onPressed,
      _text = text,
      _icon = icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 8.0),
                  child: _icon,
                ),
                BoldText3(text: _text, context: context, color: Theme.of(context).colorScheme.callToAction)
              ],
            ),
          ),
        ),
      ),
    );
  }
}