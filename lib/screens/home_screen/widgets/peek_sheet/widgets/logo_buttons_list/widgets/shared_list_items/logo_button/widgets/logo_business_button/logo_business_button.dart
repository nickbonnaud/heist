import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/screens/business_screen/business_screen.dart';

import 'bloc/logo_business_button_bloc.dart';

class LogoBusinessButton extends StatelessWidget {
  final Business _business;
  final double _logoBorderRadius;
  final Alignment _buttonAlignment;

  LogoBusinessButton({
    @required Business business,
    @required double logoBorderRadius,
    @required Alignment buttonAlignment
  })
    : assert(business != null && logoBorderRadius != null && buttonAlignment != null),
      _business = business,
      _logoBorderRadius = logoBorderRadius,
      _buttonAlignment = buttonAlignment;

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _toggleButtonPress(context: context),
      onTapUp: (_) => _toggleButtonPress(context: context),
      onTap: () => _showBusinessSheet(context: context),
      child: BlocBuilder<LogoBusinessButtonBloc, LogoBusinessButtonState>(
        builder: (context, state) {
          return Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            elevation: state.pressed ? 0 : 5,
            child: Hero(
              tag: _business.identifier, 
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(_logoBorderRadius),
                  right: Radius.circular(_logoBorderRadius),
                ),
                child: Image.network(
                  _business.photos.logo.smallUrl,
                  fit: BoxFit.cover,
                  alignment: _buttonAlignment,
                )
              )
            ),
          );
        }
      )
    );
  }

  void _toggleButtonPress({@required BuildContext context}) {
    BlocProvider.of<LogoBusinessButtonBloc>(context).add(TogglePressed());
  }

  void _showBusinessSheet({@required BuildContext context}) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      fullscreenDialog: true,
      pageBuilder: (BuildContext context, _, __) => BusinessScreen(business: _business)
    ));
  }
}

