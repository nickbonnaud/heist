import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/business_screen/business_screen.dart';

class ShowBusinessButton extends StatefulWidget {
  final Business _business;

  ShowBusinessButton({@required Business business})
    : assert(business != null),
      _business = business;

  @override
  State<ShowBusinessButton> createState() => _ShowBusinessButtonState();
}

class _ShowBusinessButtonState extends State<ShowBusinessButton> {
  bool _buttonDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        shape: CircleBorder(),
        elevation: _buttonDown ? 0 : 5,
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget._business.photos.logo.smallUrl),
          radius: SizeConfig.getWidth(8),
        ),
      ),
      onTapDown: (_) => setState(() {
        _buttonDown = true;
      }),
      onTapUp: (_) => setState(() {
        _buttonDown = false;
      }),
      onTap: () => showPlatformModalSheet(
        context: context,
        builder: (_) => BusinessScreen(business: widget._business),
      )
    );
  }
}