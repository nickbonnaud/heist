import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color _backgroundColor;
  final bool _isSliver;
  final Widget? _trailingWidget;
  final String? _title;

  DefaultAppBar({required BuildContext context, bool isSliver = false, Widget? trailingWidget, Color? backgroundColor, String? title})
    : _backgroundColor = backgroundColor == null
        ? Theme.of(context).colorScheme.topAppBar
        : backgroundColor,
      _isSliver = isSliver,
      _trailingWidget = trailingWidget,
      _title = title;
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (_isSliver) {
      return _buildSliverAppBar(context: context);
    }
    return _buildDefaultAppBar(context: context);
    
  }

  AppBar _buildDefaultAppBar({required BuildContext context}) {
    return AppBar(
      title: _title != null ? BoldText2(text: _title!, context: context) : null,
      elevation: 0,
      backgroundColor: _backgroundColor,
      leading: AnimatedLeadingIcon(),
      actions: <Widget>[
        if (_trailingWidget != null)
          _trailingWidget!
      ],
    );
  }

  SliverAppBar _buildSliverAppBar({required BuildContext context}) {
    return SliverAppBar(
      title: _title != null ? BoldText2(text: _title!, context: context) : null,
      elevation: 0,
      backgroundColor: _backgroundColor,
      leading: AnimatedLeadingIcon(),
      actions: <Widget>[
        if (_trailingWidget != null)
          _trailingWidget!
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
  late Animation _rotateAnimation;
  late AnimationController _rotateAnimationController;
  
  @override
  void initState() {
    super.initState();
    _rotateAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _rotateAnimation = Tween(begin: 0.0, end: - pi / 2).animate(_rotateAnimationController);
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
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            color: Theme.of(context).colorScheme.topAppBarIcon,
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