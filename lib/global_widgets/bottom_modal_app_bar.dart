import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/themes/global_colors.dart';

class BottomModalAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color _backgroundColor;
  final bool _isSliver;
  final Widget _trailingWidget;

  BottomModalAppBar({Color backgroundColor, bool isSliver = false, Widget trailingWidget})
    : _backgroundColor = backgroundColor,
      _isSliver = isSliver,
      _trailingWidget = trailingWidget;
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<BottomModalAppBar> createState() => _BottomModalAppBarState();
}

class _BottomModalAppBarState extends State<BottomModalAppBar> with TickerProviderStateMixin {
  Animation _showAnimation;
  AnimationController _showAnimationController;
  
  @override
  void initState() {
    super.initState();
    _showAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _showAnimation = Tween(begin: pi / 2, end: 0.0).animate(_showAnimationController);
    _showAnimationController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget._isSliver) {
      return _buildSliverAppBar(context: context);
    }
    return _buildDefaultAppBar(context: context);
  }

  SliverAppBar _buildSliverAppBar({@required BuildContext context}) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      elevation: 0,
      backgroundColor: _setBackgroundColor(context: context),
      actions: <Widget>[
        if (widget._trailingWidget != null)
          widget._trailingWidget
      ],
      leading: _builder(context: context),
    );
  }

  AppBar _buildDefaultAppBar({@required BuildContext context}) {
    return AppBar(
      elevation: 0,
      backgroundColor: _setBackgroundColor(context: context),
      actions: <Widget>[
        if (widget._trailingWidget != null)
          widget._trailingWidget
      ],
      leading: _builder(context: context)
    );
  }

  Color _setBackgroundColor({@required BuildContext context}) {
    return widget._backgroundColor == null 
        ? Theme.of(context).colorScheme.background
        : widget._backgroundColor;
  }

  AnimatedBuilder _builder({@required BuildContext context}) {
    return AnimatedBuilder(
      animation: _showAnimationController, 
      builder: (context, child) => Transform.rotate(
        angle: _showAnimation.value,
        child: IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.topAppBarIcon,
          iconSize: SizeConfig.getWidth(10),
        ),
      )
    );
  }

  @override
  void dispose() {
    _showAnimationController.dispose();
    super.dispose();
  }
}