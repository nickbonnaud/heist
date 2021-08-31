
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/themes/main_theme.dart';

import 'widgets/animated_leading_icon.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color _backgroundColor;
  final bool _isSliver;
  final Widget? _trailingWidget;
  final String? _title;

  DefaultAppBar({bool isSliver = false, Widget? trailingWidget, Color? backgroundColor, String? title})
    : _backgroundColor = backgroundColor == null
        ? MainTheme.topAppBar
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
      title: _title != null
        ? AppBarTitle(text: _title!)
        : null,
      elevation: 0,
      backgroundColor: _backgroundColor,
      leading: AnimatedLeadingIcon(),
      actions: [
        if (_trailingWidget != null)
          _trailingWidget!
      ],
    );
  }

  SliverAppBar _buildSliverAppBar({required BuildContext context}) {
    return SliverAppBar(
      title: _title != null
        ? AppBarTitle(text: _title!)
        : null,
      elevation: 0,
      backgroundColor: _backgroundColor,
      leading: AnimatedLeadingIcon(),
      actions: [
        if (_trailingWidget != null)
          _trailingWidget!
      ],
      floating: true,
      pinned: false,
      snap: false,
    );
  }
}