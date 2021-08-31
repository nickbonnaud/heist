import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/screens/auth_screen/auth_screen.dart';
import 'package:heist/screens/auth_screen/widgets/cubit/keyboard_visible_cubit.dart';
import 'package:heist/screens/auth_screen/widgets/page_offset_notifier.dart';
import 'package:provider/provider.dart';

class WelcomeLabel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          top: (1 - animation.value) * (mainSquareSize(context: context) + topMargin(context: context) + 32.h) + (animation.value * 50.h),
          left: 24.w - notifier.offset,
          child: BlocBuilder<KeyboardVisibleCubit, bool>(
            builder: (context, keyboardVisible) {
              return Opacity(
                opacity: _setVisibility(notifier: notifier, keyboardVisible: keyboardVisible),
                child: child,
              );
            },
          )
        );
      },
      child: Text(
        'Login',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 35.sp,
        ),
      )
    );
  }

  double _setVisibility({required PageOffsetNotifier notifier, required bool keyboardVisible}) {
    return keyboardVisible ? 0.2 : 1 - (2 * notifier.page);
  }
}