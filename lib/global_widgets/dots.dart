import 'package:flutter/material.dart';

class Dots extends StatelessWidget {
  final int _slideIndex;
  final int _numberOfDots;

  Dots({@required slideIndex, @required numberOfDots})
    : assert(slideIndex != null && numberOfDots != null),
      _slideIndex = slideIndex,
      _numberOfDots = numberOfDots;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _generateDots(),
      ),
    );
  }

  List<Widget> _generateDots() {
    List<Widget> dots = [];
    for (int i = 0; i < _numberOfDots; i++) {
      dots.add(i == _slideIndex ? _activeSlide(i) : _inactiveSlide(i));
    }
    return dots;
  }

  Widget _activeSlide(int index) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );
  }

  Widget _inactiveSlide(int index) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          width: 14.0,
          height: 14.0,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );
  }
}