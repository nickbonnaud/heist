import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';

import 'widgets/takeoff_control.dart';

class PermissionsAnimation extends StatefulWidget {
  final PermissionsBloc _permissionsBloc;

  const PermissionsAnimation({required PermissionsBloc permissionsBloc, Key? key})
    : _permissionsBloc = permissionsBloc,
      super(key: key);

  @override
  State<PermissionsAnimation> createState() => _PermissionsAnimationState();
}

class _PermissionsAnimationState extends State<PermissionsAnimation> {
  final TakeoffControl _controls = TakeoffControl();

  late StreamSubscription _animationCompleteListener;
  late List<PermissionType> _invalidPermissions;
  late String _initialAnimation;
  late String _currentAnimation;
  late String _nextAnimation;
  
  @override
  void initState() {
    super.initState();
    _invalidPermissions = widget._permissionsBloc.invalidPermissions;
    _initialAnimation = _setInitialAnimation(incompletePermissions: _invalidPermissions.length);
    _currentAnimation = _initialAnimation;
    _nextAnimation = _setNextAnimation();
    _animationListener(context: context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionsBloc, PermissionsState>(
      listener: (context, state) {
        if (BlocProvider.of<PermissionsBloc>(context).invalidPermissions.length < _invalidPermissions.length) {
          _invalidPermissions = BlocProvider.of<PermissionsBloc>(context).invalidPermissions;
          _playNext();
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: FlareActor(
          'assets/permissions.flr',
          animation: _initialAnimation,
          artboard: 'artboard',
          controller: _controls,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controls.dispose();
    _animationCompleteListener.cancel();
    super.dispose();
  }

  void _playNext() {
    _controls.play(_nextAnimation);
    _currentAnimation = _nextAnimation;
    _nextAnimation = _setNextAnimation();
  }
  
  String _setNextAnimation() {
    String nextAnimation;
    switch (_currentAnimation) {
      case 'stage_1':
        nextAnimation = 'stage_2';
        break;
      case 'stage_2':
        nextAnimation = 'stage_2_3_transition';
        break;
      case 'stage_2_3_transition':
        nextAnimation = 'stage_3';
        break;
      case 'stage_3':
        nextAnimation = 'stage_3_4_transition';
        break;
      case 'stage_3_4_transition':
        nextAnimation = 'stage_4';
        break;
      case 'stage_4':
        nextAnimation = 'end';
        break;
      default:
        nextAnimation = "";
    }
    return nextAnimation;
  }
  
  String _setInitialAnimation({required int incompletePermissions}) {
    String animationName;
    switch (incompletePermissions) {
      case 4:
        animationName = 'stage_1';
        break;
      case 3:
        animationName = 'stage_2';
        break;
      case 2:
        animationName = 'stage_3';
        break;
      case 1:
        animationName = 'stage_4';
        break;
      default:
        animationName = "";
    }
    return animationName;
  }
  
  void _animationListener({required BuildContext context}) {
    _animationCompleteListener = _controls.animationCompleted.listen((animationName) { 
      if (animationName == 'stage_2_3_transition') {
        _playNext();
      }

      if (animationName == 'stage_3_4_transition') {
        _playNext();
      }

      if (animationName == 'end') {
        Navigator.of(context).pop();
      }
    });
  }
}