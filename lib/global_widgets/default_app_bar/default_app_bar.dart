import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color _backgroundColor;
  final bool _isSliver;
  final Widget _trailingWidget;

  DefaultAppBar({Color backgroundColor = Colors.white, bool isSliver = false, Widget trailingWidget})
    : _backgroundColor = backgroundColor,
      _isSliver = isSliver,
      _trailingWidget = trailingWidget;
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (_isSliver) {
      return _buildSliverAppBar();
    }
    return _buildDefaultAppBar();
    
  }

  AppBar _buildDefaultAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _backgroundColor,
      leading: AnimatedLeadingIcon(),
      actions: <Widget>[
        if (_trailingWidget != null)
          _trailingWidget
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: _backgroundColor,
      leading: AnimatedLeadingIcon(),
      actions: <Widget>[
        if (_trailingWidget != null)
          _trailingWidget
      ],
      floating: true,
      pinned: false,
      snap: false,
    );
  }
}

class AnimatedLeadingIcon extends StatefulWidget{
  @override
  State<AnimatedLeadingIcon> createState() => _AnimatedLeadingIconState();
}

class _AnimatedLeadingIconState extends State<AnimatedLeadingIcon> with TickerProviderStateMixin {
  Animation _rotateAnimation;
  AnimationController _rotateAnimationController;
  
  @override
  void initState() {
    _rotateAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _rotateAnimation = Tween(begin: 0.0, end: - pi / 2).animate(_rotateAnimationController);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<DefaultAppBarBloc, DefaultAppBarState>(
      listener: (context, state) {
        if (state.isRotated) {
          _rotateAnimationController.forward();
        } else if (!state.isRotated) {
          _rotateAnimationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _rotateAnimationController,
        builder: (context, child) => Transform.rotate(
          angle: _rotateAnimation.value,
          child: IconButton(
            icon: Icon(context.platformIcons.back),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.black,
            iconSize: SizeConfig.getWidth(10),
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _rotateAnimationController.dispose();
    super.dispose();
  }
}