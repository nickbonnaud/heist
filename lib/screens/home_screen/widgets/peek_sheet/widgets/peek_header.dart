import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';

import 'logo_buttons_list/bloc/logo_buttons_list_bloc.dart';

class PeekHeader extends StatelessWidget {
  final double _fontSize;
  final double _topMargin;
  final double _buttonSize;
  final AnimationController _controller;

  PeekHeader({required double fontSize, required double topMargin, required double buttonSize, required AnimationController controller})
    : assert(fontSize != null && topMargin != null && buttonSize != null && controller != null),
      _fontSize = fontSize,
      _topMargin = topMargin,
      _buttonSize = buttonSize,
      _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topMargin,
      left: 8,
      right: _buttonSize + SizeConfig.getWidth(1),
      child: BlocBuilder<LogoButtonsListBloc, LogoButtonsListState>(
        builder: (context, state) {
          return PlatformText(
            _setHeader(state: state),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: _fontSize,
              fontWeight: FontWeight.w500
            ),
          );
        }
      )
    );
  }

  String _setHeader({required LogoButtonsListState state}) {
    if (_controller.status == AnimationStatus.completed) {
      if (state.numberOpenTransactions > 0) {
        return  state.numberOpenTransactions > 1 ? "Open Transactions" : "Open Transaction";
      } else if (state.numberActiveLocations > 0) {
        return "Active Locations";
      } else {
        return 'Nearby Businesses';
      }
    } else {
      return "Location Details";
    }
  }
}