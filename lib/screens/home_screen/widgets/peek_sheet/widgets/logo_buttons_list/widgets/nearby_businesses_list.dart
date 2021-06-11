import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/screens/home_screen/widgets/peek_sheet/widgets/logo_buttons_list/widgets/shared_list_items/logo_details/business_logo_details.dart';

import 'shared_list_items/logo_button/logo_button.dart';
import 'shared_list_items/logo_divider.dart';
import 'shared_list_items/shared_sizes.dart';

class NearbyBusinessesList extends StatelessWidget {
  final int _numberOpenTransactions;
  final int _numberActiveLocations;
  final AnimationController _controller;
  final double _topMargin;

  final SharedSizes sharedSizes = SharedSizes();

  double get _size => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);
  double get _borderRadius => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);

  NearbyBusinessesList({
    required int numberOpenTransactions,
    required int numberActiveLocations,
    required AnimationController controller,
    required double topMargin
  })
    : assert(numberOpenTransactions != null && numberActiveLocations != null && controller != null && topMargin != null),
      _numberOpenTransactions = numberOpenTransactions,
      _numberActiveLocations = numberActiveLocations,
      _controller = controller,
      _topMargin = topMargin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearbyBusinessesBloc, NearbyBusinessesState>(
      buildWhen: (previousState, state) => previousState != state,
      builder: (context, state) {
        final currentState = state;
        if (currentState is NearbyBusinessLoaded) {
          return Stack(
            children: <Widget>[
              if (_showDivider())
                LogoDivider(
                  numberPreviousWidgets: _numberOpenTransactions + _numberActiveLocations + (_numberOpenTransactions > 0 && _numberActiveLocations > 0 ? 1 : 0), 
                  controller: _controller, 
                  topMargin: _topMargin, 
                  isActiveLocationDivider: false
                ),
              for (Business business in currentState.businesses.take(_numberNearbyToShow())) _buildDetails(business: business, state: currentState),
              for (Business business in currentState.businesses.take(_numberNearbyToShow())) _buildLogoButton(business: business, state: currentState),
            ],
          );
        }
        return Container();
      },
    );
  }
  
  
  int _setIndex({required NearbyBusinessLoaded state, required Business business}) {
    return _setPreviousIndex() + state.businesses.indexOf(business);
  }

  int _setPreviousIndex() {
    return _numberOpenTransactions + _numberActiveLocations + _numberOfDividers();
  }
  
  int _numberOfDividers() {
    if (_numberOpenTransactions > 0 && _numberActiveLocations > 0) {
      return 2;
    } else if (_numberOpenTransactions > 0 || _numberActiveLocations > 0) {
      return 1;
    } else {
      return 0;
    }
  }
  
  int _numberNearbyToShow() {
    final int numberSlotsLeft = 6 - (_numberOpenTransactions + _numberActiveLocations);
    return numberSlotsLeft <= 0 ? 3 : numberSlotsLeft;
  }
  
  Widget _buildLogoButton({required Business business, required NearbyBusinessLoaded state}) {
    int index = _setIndex(state: state, business: business);
    return LogoButton(
      controller: _controller, 
      topMargin: _logoMarginTop(index: index),
      leftMargin: _logoLeftMargin(index: index),
      isTransaction: false,
      logoSize: _size,
      borderRadius: _borderRadius,
      business: business,
    );
  }

  Widget _buildDetails({required Business business, required NearbyBusinessLoaded state}) {
    int index = _setIndex(state: state, business: business);
    return BusinessLogoDetails(
      topMargin: _logoMarginTop(index: index), 
      leftMargin: _logoLeftMargin(index: index), 
      height: _size, 
      controller: _controller,
      borderRadius: _borderRadius, 
      business: business,
      index: index
    );
  }

  bool _showDivider() {
    return _numberOpenTransactions > 0 || _numberActiveLocations > 0;
  }

  double _logoMarginTop({required int index}) {
    return lerp(
      min: sharedSizes.startMarginTop,
      max: sharedSizes.endMarginTop + (index * (sharedSizes.verticalSpacing + sharedSizes.endSize))
    ) + _topMargin;
  }

  double _logoLeftMargin({required int index}) {
    return lerp(
      min: index == 0 ? 3 : index * ((sharedSizes.horizontalSpacing + sharedSizes.startSize)),
      max: 8
    );
  }
  
  double lerp({required double min, required double max}) {
    return lerpDouble(min, max, _controller.value)!;
  }
}