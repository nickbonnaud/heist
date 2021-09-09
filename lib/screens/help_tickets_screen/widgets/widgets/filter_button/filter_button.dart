import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/filter_button_bloc.dart';

class FilterButton extends StatefulWidget {
  final Color _startColor;
  final Color _endColor;

  FilterButton({required Color startColor, required Color endColor})
    : _startColor = startColor,
      _endColor = endColor;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> with SingleTickerProviderStateMixin {
  final double _expandedSize = 225.sp;
  final double _hiddenSize = 1.sp;
  final double _topPoint = 2 * math.pi * 1.2;
  final double _bottomPoint =  2 * math.pi * .68;
  
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200)
    );
    _colorAnimation = ColorTween(
      begin: widget._startColor,
      end: widget._endColor,
    ).animate(_controller);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<FilterButtonBloc, FilterButtonState>(
      listener: (context, state) {
        state.isActive ? _open() : _close();
      },
      child: SizedBox(
        width: _expandedSize,
        height: _expandedSize,
        child: AnimatedBuilder(
          animation: _controller, 
          builder: (BuildContext context, Widget? child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _buildExpandedBackground(),
                _buildOption(
                  option: Option.all, 
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.onSecondary
                  ), 
                  angle: _setAngle(index: 1)
                ),
                _buildOption(
                  option: Option.open, 
                  icon: Icon(
                    Icons.lock_open,
                    color: Theme.of(context).colorScheme.onSecondary
                  ), 
                  angle: _setAngle(index: 2)
                ),
                _buildOption(
                  option: Option.resolved, 
                  icon: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.onSecondary
                  ), 
                  angle: _setAngle(index: 3)
                ),
                _buildBaseButton(),
              ],
            );
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildExpandedBackground() {
    double size = _hiddenSize + (_expandedSize - _hiddenSize) * _controller.value;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        color: _controller.value > 0.01 ? Theme.of(context).colorScheme.secondary : Colors.transparent,
      )
    );
  }

  double _setAngle({required int index}) {
    final double length = (_topPoint - _bottomPoint) / Option.values.length;
    return _topPoint - (length * index);
  }
  
  Widget _buildOption({required Option option, required Widget icon, required double angle}) {
    if (_controller.isDismissed) {
      return Container();
    }

    double iconSize = 0.0;
    if (_controller.value > 0.8) {
      iconSize = 35.sp * (_controller.value - 0.8) * 5;
    }

    return Transform.rotate(
      angle: angle,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: IconButton(
            onPressed: () => _onSelection(option: option),
            icon: Transform.rotate(
              angle: -angle,
              child: icon,
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  void _onSelection({required Option option}) {
    BlocProvider.of<FilterButtonBloc>(context).add(Toggle());
    switch (option) {
      case Option.all:
        _fetchAll();
        break;
      case Option.open:
        _fetchOpen();
        break;
      case Option.resolved:
        _fetchResolved();
        break;
    }
  }

  void _fetchAll() {
    BlocProvider.of<HelpTicketsScreenBloc>(context).add(FetchAll(reset: true));
  }

  void _fetchOpen() {
    BlocProvider.of<HelpTicketsScreenBloc>(context).add(FetchOpen(reset: true));
  }

  void _fetchResolved() {
    BlocProvider.of<HelpTicketsScreenBloc>(context).add(FetchResolved(reset: true));
  }

  Widget _buildBaseButton() {
    double scaleFactor = 2 * (_controller.value - 0.5).abs();
    return BlocBuilder<FilterButtonBloc, FilterButtonState>(
      builder: (context, state) {
        return FloatingActionButton(
          key: Key("helpTicketsFilterButtonKey"),
          onPressed: () => BlocProvider.of<FilterButtonBloc>(context).add(Toggle()),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(1.0, scaleFactor),
            child: Icon(
              state.isActive ? Icons.close : Icons.filter_list,
              size: 45.sp,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          backgroundColor: _colorAnimation.value,
        );
      }
    );
  }

  void _open() {
    if (_controller.isDismissed) {
      _controller.forward();
    }
  }

  void _close() {
    if (_controller.isCompleted) {
      _controller.reverse();
    }
  }
}