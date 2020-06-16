import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/screens/profile_setup_screen/widgets/pages/profile_finished_screen.dart';


import 'pages/intro_screen.dart';
import 'pages/profile_name_screen/profile_name_screen.dart';
import 'pages/profile_photo_screen.dart';
import 'pages/setup_payment_account_screen.dart';
import 'pages/setup_tip_screen.dart/setup_tip_screen.dart';


class ProfileSetupScreenBody extends StatefulWidget {
  
  @override
  State<ProfileSetupScreenBody> createState() => _ProfileSetupScreenBodyState();
}

class _ProfileSetupScreenBodyState extends State<ProfileSetupScreenBody> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimationFirst;
  Animation<Offset> _offsetAnimationSecond;

  bool _doAnimate = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          _doAnimate = true;
        });
      } else if (status == AnimationStatus.completed) {
        setState(() {
          _doAnimate = false;
        });
        _controller.reset();
      }
    });

    _offsetAnimationFirst = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.5)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn
    ));

    _offsetAnimationSecond = Tween<Offset>(
      begin: Offset(0.0, 1.5),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSetupScreenBloc, ProfileSetupScreenState>(
      listener: (context, state) => state.isComplete ? Future.delayed(Duration(seconds: 2), () => Navigator.of(context).pop()) : null,
      child: _buildBody(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    return AnimatedCrossFade(
      firstChild: SlideTransition(
        position: _offsetAnimationFirst,
        child: BlocBuilder<ProfileSetupScreenBloc, ProfileSetupScreenState>(
          builder: (context, state) {
            return _buildFirstScreen(state: state);
          },
        ),
      ), 
      secondChild: SlideTransition(
        position: _offsetAnimationSecond,
        child: BlocBuilder<ProfileSetupScreenBloc, ProfileSetupScreenState>(
          builder: (context, state) {
            return _buildSecondScreen(state: state);
          },
        ),
      ),
      crossFadeState: (!_doAnimate) ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
      duration: Duration(seconds: 1)
    );

  }

  Widget _buildFirstScreen({@required ProfileSetupScreenState state}) {
    if (!state.isIntroComplete) {
      return IntroScreen(controller: _controller);
    } else if (!state.isNameComplete) {
      return ProfileNameScreen(controller: _controller);
    } else if (!state.isPhotoComplete) {
      return ProfilePhotoScreen(controller: _controller);
    } else if (!state.isTipComplete) {
      return SetupTipScreen(controller: _controller);
    } else if (!state.isPaymentAccountComplete) {
      return SetupPaymentAccountScreen(controller: _controller);
    } else {
      return ProfileFinishedScreen();
    }
  }

  Widget _buildSecondScreen({@required ProfileSetupScreenState state}) {
    if (!state.isIntroComplete) {
      return ProfileNameScreen(controller: _controller);
    } else if (!state.isNameComplete) {
      return ProfilePhotoScreen(controller: _controller);
    } else if (!state.isPhotoComplete) {
      return  SetupTipScreen(controller: _controller);
    } else if (!state.isTipComplete) {
      return SetupPaymentAccountScreen(controller: _controller);
    } else {
      return ProfileFinishedScreen();
    }
  }
}