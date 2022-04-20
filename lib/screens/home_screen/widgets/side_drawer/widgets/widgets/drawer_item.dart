import 'package:flutter/material.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItem extends StatelessWidget {
  final VoidCallback _onPressed;
  final String _text;
  final Widget _icon;

  const DrawerItem({required Key key, required VoidCallback onPressed, required String text, required Widget icon})
    : _onPressed = onPressed,
      _text = text,
      _icon = icon,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _icon,
                ),
                Text(
                  _text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp,
                    color: Theme.of(context).colorScheme.callToAction
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}