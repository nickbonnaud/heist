import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dots extends StatelessWidget {
  final int _slideIndex;
  final int _numberOfDots;

  const Dots({required int slideIndex, required int numberOfDots, Key? key})
    : _slideIndex = slideIndex,
      _numberOfDots = numberOfDots,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _generateDots(context: context),
      ),
    );
  }

  List<Widget> _generateDots({required BuildContext context}) {
    List<Widget> dots = [];
    for (int i = 0; i < _numberOfDots; i++) {
      dots.add(i == _slideIndex ? _activeSlide(index: i, context: context) : _inactiveSlide(index: i, context: context));
    }
    return dots;
  }

  Widget _activeSlide({required int index, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: 25.sp,
        height: 25.sp,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(50.sp)
        ),
      ),
    );
  }

  Widget _inactiveSlide({required int index, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
          borderRadius: BorderRadius.circular(50.sp)
        ),
      ),
    );
  }
}