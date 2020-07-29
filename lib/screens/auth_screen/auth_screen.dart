import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/app_name.dart';
import 'widgets/background_circle.dart';
import 'widgets/drag_arrow.dart';
import 'widgets/first_image.dart';
import 'widgets/form_animation_notifier.dart';
import 'widgets/forms/forms.dart';
import 'widgets/last_image.dart';
import 'widgets/page_indicator.dart';
import 'widgets/page_offset_notifier.dart';

double topMargin({@required BuildContext context}) => MediaQuery.of(context).size.height > 700 ? 128 : 64;
double mainSquareSize({@required BuildContext context}) => MediaQuery.of(context).size.height / 2;

class AuthScreen extends StatefulWidget {

  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  AnimationController _animationController;
  AnimationController _formAnimationController;

  double get maxHeight => mainSquareSize(context: context) + 32 + 24;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _formAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    Future.delayed(Duration(seconds: 1)).then((value) => _animationController.forward());

    _pageController.addListener(() {
      if (_pageController.page == 1) {
        _animationController.forward();
      } else if (_pageController.page == 0) {
        _animationController.forward();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageOffsetNotifier(_pageController),
      child: ListenableProvider.value(
        value: _animationController,
        child: ChangeNotifierProvider(
          create: (_) => FormAnimationNotifier(_formAnimationController),
          child: Scaffold(
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.grey.shade900,
            body: Stack(
              children: <Widget>[
                SafeArea(
                  child: GestureDetector(
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        PageView(
                          controller: _pageController,
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            AppName(),
                            BackgroundCircle()
                          ],
                        ),
                        FirstImage(),
                        LastImage(),
                        Forms(pageController: _pageController),
                        PageIndicator(),
                        DragArrow()
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
        ) 
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _formAnimationController.dispose();
    super.dispose();
  }
}