import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/screens/home_screen/widgets/home_screen_body/widgets/peek_sheet/widgets/logo_buttons_list/bloc/logo_buttons_list_bloc.dart';

import 'shared_list_items/logo_button/logo_button.dart';
import 'shared_list_items/logo_details/business_logo_details/business_logo_details.dart';
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
    : _numberOpenTransactions = numberOpenTransactions,
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
            children: [_divider()]
              ..addAll(_detailsList(context: context, state: currentState))
              ..addAll(_buttonsList(context: context, state: currentState))
          );
        }
        return Container();
      },
    );
  }

  Widget _divider() {
    if (_numberOpenTransactions > 0 || _numberActiveLocations > 0) {
      return LogoDivider(
        numberPreviousWidgets: _numberOpenTransactions + _numberActiveLocations + (_numberOpenTransactions > 0 && _numberActiveLocations > 0 ? 1 : 0), 
        controller: _controller, 
        topMargin: _topMargin, 
        isActiveLocationDivider: false
      );
    }
    return Container();
  }
  
  List<Widget> _detailsList({required BuildContext context, required NearbyBusinessLoaded state}) {
    List<Business> nonActiveLocations = BlocProvider.of<LogoButtonsListBloc>(context).nonActiveNearby;
    int numberNearbyToShow = BlocProvider.of<LogoButtonsListBloc>(context).numberNearbySlots;

    return List<Widget>.generate(numberNearbyToShow, (index) => _buildDetails(
      context: context,
      business: nonActiveLocations[index],
      state: state,
      subListIndex: index
    ));
  }

  List<Widget> _buttonsList({required BuildContext context, required NearbyBusinessLoaded state}) {
    List<Business> nonActiveLocations = BlocProvider.of<LogoButtonsListBloc>(context).nonActiveNearby;
    int numberNearbyToShow = BlocProvider.of<LogoButtonsListBloc>(context).numberNearbySlots;
    
    return List<Widget>.generate(numberNearbyToShow, (index) => _buildLogoButton(
      context: context,
      business: nonActiveLocations[index],
      state: state,
      subListIndex: index
    ));
  }

  // List<Business> _getNonActiveLocations({required BuildContext context, required List<Business> businesses}) {
  //   return businesses.where((business) {
  //     return !BlocProvider.of<ActiveLocationBloc>(context).state.activeLocations
  //       .any((activeLocation) => activeLocation.beaconIdentifier == business.location.beacon.identifier);
  //   }).toList();
  // }
  
  int _setIndex({required BuildContext context, required NearbyBusinessLoaded state, required Business business}) {
    List<Business> nonActiveLocations = BlocProvider.of<LogoButtonsListBloc>(context).nonActiveNearby;
    return _setPreviousIndex() + nonActiveLocations.indexOf(business);
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
  
  // int _numberNearbyToShow({required int numberNonActiveLocations}) {
  //   final int numberSlotsLeft = 6 - (_numberOpenTransactions + _numberActiveLocations);
  //   final int slotsToShow = numberSlotsLeft <= 0 ? 3 : numberSlotsLeft;
  //   return slotsToShow > numberNonActiveLocations ? numberNonActiveLocations : slotsToShow;
  // }
  
  Widget _buildLogoButton({required BuildContext context, required Business business, required NearbyBusinessLoaded state, required int subListIndex}) {
    final int fullIndex = _setIndex(context: context, state: state, business: business);
    
    return LogoButton(
      keyValue: "nearbyLogoButtonKey-$subListIndex",
      controller: _controller, 
      topMargin: _logoMarginTop(index: fullIndex),
      leftMargin: _logoLeftMargin(index: fullIndex),
      isTransaction: false,
      logoSize: _size,
      borderRadius: _borderRadius,
      business: business,
    );
  }

  Widget _buildDetails({required BuildContext context, required Business business, required NearbyBusinessLoaded state, required int subListIndex}) {
    final int fullIndex = _setIndex(context: context, state: state, business: business);
    
    return BusinessLogoDetails(
      keyValue: "nearbyDetailsKey-$subListIndex",
      topMargin: _logoMarginTop(index: fullIndex), 
      leftMargin: _logoLeftMargin(index: fullIndex), 
      height: _size, 
      controller: _controller,
      borderRadius: _borderRadius, 
      business: business,
      subListIndex: subListIndex
    );
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