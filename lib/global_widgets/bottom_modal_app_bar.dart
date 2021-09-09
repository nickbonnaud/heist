import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomModalAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color _backgroundColor;
  final bool _isSliver;
  final Widget? _trailingWidget;
  final String? _title;

  BottomModalAppBar({required BuildContext context, bool isSliver = false, Widget? trailingWidget, Color? backgroundColor, String? title})
    : _backgroundColor = backgroundColor == null
        ? Theme.of(context).colorScheme.background
        : backgroundColor,
      _isSliver = isSliver,
      _trailingWidget = trailingWidget,
      _title = title;
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<BottomModalAppBar> createState() => _BottomModalAppBarState();
}

class _BottomModalAppBarState extends State<BottomModalAppBar> with TickerProviderStateMixin {
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
    if (widget._isSliver) {
      return _buildSliverAppBar(context: context);
    }
    return _buildDefaultAppBar(context: context);
  }

  SliverAppBar _buildSliverAppBar({required BuildContext context}) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      elevation: 0,
      backgroundColor: widget._backgroundColor,
      actions: [
        if (widget._trailingWidget != null)
          widget._trailingWidget!
      ],
      leading: _builder(context: context),
    );
  }

  AppBar _buildDefaultAppBar({required BuildContext context}) {
    return AppBar(
      title: widget._title != null
        ? AppBarTitle(text: widget._title!)
        : null,
      elevation: 0,
      backgroundColor: widget._backgroundColor,
      actions: [
        if (widget._trailingWidget != null)
          widget._trailingWidget!
      ],
      leading: _builder(context: context)
    );
  }

  AnimatedBuilder _builder({required BuildContext context}) {
    return AnimatedBuilder(
      animation: _showAnimationController, 
      builder: (context, child) => Transform.rotate(
        angle: _showAnimation.value,
        child: IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.topAppBarIcon,
          iconSize: 45.sp,
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