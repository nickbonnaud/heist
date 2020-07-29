import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/screens/business_screen/business_screen.dart';
import 'package:transparent_image/transparent_image.dart';

import 'bloc/logo_business_button_bloc.dart';

class LogoBusinessButton extends StatelessWidget {
  final Business _business;
  final double _logoBorderRadius;

  LogoBusinessButton({
    @required Business business,
    @required double logoBorderRadius,
  })
    : assert(business != null && logoBorderRadius != null),
      _business = business,
      _logoBorderRadius = logoBorderRadius;

  
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
            child: CachedNetworkImage(
              imageUrl: _business.photos.logo.smallUrl,
              imageBuilder: (context, imageProvider) => Hero(
                tag: _business.identifier, 
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: _logoBorderRadius,
                )
              ),
              placeholder: (_,__) => Image.memory(kTransparentImage),
            )
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

