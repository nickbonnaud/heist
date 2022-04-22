import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/screens/auth_screen/widgets/background.dart';
import 'package:provider/provider.dart';

import 'widgets/app_name.dart';
import 'widgets/cubit/keyboard_visible_cubit.dart';
import 'widgets/drag_arrow.dart';
import 'widgets/form_animation_notifier.dart';
import 'widgets/forms/forms.dart';
import 'widgets/page_indicator.dart';
import 'widgets/page_offset_notifier.dart';

double topMargin({required BuildContext context}) => MediaQuery.of(context).size.height > 700.h ? 192.h : 128.h;
double mainSquareSize({required BuildContext context}) => MediaQuery.of(context).size.height / 2;

class AuthScreen extends StatefulWidget {

  const AuthScreen({Key? key})
    : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late AnimationController _formAnimationController;

  double get maxHeight => mainSquareSize(context: context) + 32.h + 24.h;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _formAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(const Duration(milliseconds: 500)).then((value) => _animationController.forward());

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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 13, 35, 1),
      body: ChangeNotifierProvider(
        create: (_) => PageOffsetNotifier(pageController: _pageController),
        child: ListenableProvider.value(
          value: _animationController,
          child: ChangeNotifierProvider(
            create: (_) => FormAnimationNotifier(_formAnimationController),
            child: Stack(
              children: [
                GestureDetector(
                  key: const Key("verticalDragDetectorKey"),
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: Stack(
                    key: const Key("stackKey"),
                    alignment: Alignment.center,
                    children: [
                      Background(),
                      PageView(
                        controller: _pageController,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          const AppName(),
                          Container()
                        ],
                      ),
                      const PageIndicator(),
                      BlocProvider<KeyboardVisibleCubit>(
                        create: (_) => KeyboardVisibleCubit(),
                        child: Stack(
                          children: [
                            Forms(pageController: _pageController),
                            const DragArrow(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ) 
        ),
      )
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      _animationController.value -= details.primaryDelta! / maxHeight;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating || _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;
    
    if (flingVelocity < 0.0) {
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    } else {
      _animationController.fling(velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _formAnimationController.dispose();
    super.dispose();
  }
}