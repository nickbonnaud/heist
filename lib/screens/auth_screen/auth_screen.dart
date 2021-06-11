import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/screens/auth_screen/widgets/background.dart';
import 'package:provider/provider.dart';

import 'widgets/app_name.dart';
import 'widgets/cubit/keyboard_visible_cubit.dart';
import 'widgets/drag_arrow.dart';
import 'widgets/form_animation_notifier.dart';
import 'widgets/forms/forms.dart';
import 'widgets/page_indicator.dart';
import 'widgets/page_offset_notifier.dart';

double topMargin({required BuildContext context}) => MediaQuery.of(context).size.height > 700 ? 192 : 128;
double mainSquareSize({required BuildContext context}) => MediaQuery.of(context).size.height / 2;

class AuthScreen extends StatefulWidget {
  final AuthenticationRepository _authenticationRepository;
  final bool _permissionsReady;
  final bool _customerOnboarded; 

  AuthScreen({
    required AuthenticationRepository authenticationRepository,
    required bool permissionsReady,
    required bool customerOnboarded
  })
    : _authenticationRepository = authenticationRepository,
      _permissionsReady = permissionsReady,
      _customerOnboarded = customerOnboarded;

  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late AnimationController _formAnimationController;

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

    Future.delayed(Duration(milliseconds: 500)).then((value) => _animationController.forward());

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade900,
      body: ChangeNotifierProvider(
        create: (_) => PageOffsetNotifier(pageController: _pageController),
        child: ListenableProvider.value(
          value: _animationController,
          child: ChangeNotifierProvider(
            create: (_) => FormAnimationNotifier(_formAnimationController),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Background(),
                      PageView(
                        controller: _pageController,
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          AppName(),
                          Container()
                        ],
                      ),
                      PageIndicator(),
                      BlocProvider<KeyboardVisibleCubit>(
                        create: (_) => KeyboardVisibleCubit(),
                        child: Stack(
                          children: [
                            Forms(
                              authenticationRepository: widget._authenticationRepository,
                              pageController: _pageController,
                              permissionsReady: widget._permissionsReady,
                              customerOnboarded: widget._customerOnboarded,
                            ),
                            DragArrow(),
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