import 'package:flutter/material.dart';

class Dots extends StatelessWidget {
  final int _slideIndex;
  final int _numberOfDots;

  Dots({required slideIndex, required numberOfDots})
    : assert(slideIndex != null && numberOfDots != null),
      _slideIndex = slideIndex,
      _numberOfDots = numberOfDots;

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
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );
  }

  Widget _inactiveSlide({required int index, required BuildContext context}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          width: 14.0,
          height: 14.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );
  }
}