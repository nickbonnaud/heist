import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/themes/global_colors.dart';

class OverlayAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color _backgroundColor;
  final Widget? _trailingWidget;

  OverlayAppBar({required BuildContext context, Color? backgroundColor, Widget? trailingWidget})
    : _backgroundColor = backgroundColor == null
        ? Theme.of(context).colorScheme.background
        : backgroundColor,
      _trailingWidget = trailingWidget;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() => _OverlayAppBarState();
}

class _OverlayAppBarState extends State<OverlayAppBar> with TickerProviderStateMixin {
  late Animation _showAnimation;
  late AnimationController _showAnimationController;

  @override
  void initState() {
    super.initState();
    _showAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _showAnimation = Tween(begin: pi / 2, end: 0.0).animate(_showAnimationController);
    _showAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: widget._backgroundColor,
      actions: <Widget>[
        if (widget._trailingWidget != null)
          widget._trailingWidget!
      ],
      leading: AnimatedBuilder(
        animation: _showAnimationController, 
        builder: (context, child) => Transform.rotate(
          angle: _showAnimation.value,
          child: IconButton(
            icon: Icon(Icons.close),
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
    _showAnimationController.dispose();
    super.dispose();
  }
}