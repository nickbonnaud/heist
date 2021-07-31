import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/home_screen/blocs/business_screen_visible_cubit.dart';
import 'package:heist/screens/home_screen/blocs/side_drawer_bloc/side_drawer_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import 'bloc/logo_business_button_bloc.dart';

class LogoBusinessButton extends StatelessWidget {
  final Business _business;
  final String _keyValue;
  final double _logoBorderRadius;
  final AnimationController _controller;

  LogoBusinessButton({
    required Business business,
    required String keyValue,
    required double logoBorderRadius,
    required AnimationController controller
  })
    : _business = business,
      _keyValue = keyValue,
      _logoBorderRadius = logoBorderRadius,
      _controller = controller;

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key(_keyValue),
      onTapDown: (_) => _toggleButtonPress(context: context),
      onTapUp: (_) => _toggleButtonPress(context: context),
      onTap: () => _showBusinessSheet(context: context),
      onTapCancel: () => _toggleButtonPress(context: context),
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

  void _toggleButtonPress({required BuildContext context}) {
    BlocProvider.of<LogoBusinessButtonBloc>(context).add(TogglePressed());
  }

  void _showBusinessSheet({required BuildContext context}) {
    context.read<BusinessScreenVisibleCubit>().toggle();
    BlocProvider.of<SideDrawerBloc>(context).add(ButtonVisibilityChanged(isVisible: false));
    Navigator.of(context).pushNamed(Routes.business, arguments: _business)
      .then((_) {
        context.read<BusinessScreenVisibleCubit>().toggle();
        if (_controller.status != AnimationStatus.completed) {
          BlocProvider.of<SideDrawerBloc>(context).add(ButtonVisibilityChanged(isVisible: true));
        }
      });
  }
}

