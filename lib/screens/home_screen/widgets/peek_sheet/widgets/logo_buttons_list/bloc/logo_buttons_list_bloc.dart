import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:meta/meta.dart';

part 'logo_buttons_list_event.dart';
part 'logo_buttons_list_state.dart';

class LogoButtonsListBloc extends Bloc<LogoButtonsListEvent, LogoButtonsListState> {
  StreamSubscription _openTransactionsSubscription;
  StreamSubscription _activeLocationSubscription;
  StreamSubscription _nearbyBusinessesSubscription;

  
  LogoButtonsListBloc({
    @required OpenTransactionsBloc openTransactionsBloc, 
    @required ActiveLocationBloc activeLocationBloc, 
    @required NearbyBusinessesBloc nearbByusinessesBloc,
    @required int numberOpenTransactions,
    @required int numberActiveLocations,
    @required int numberNearbyLocations
  })
    : assert(openTransactionsBloc != null 
        && activeLocationBloc != null 
        && nearbByusinessesBloc != null
        && numberOpenTransactions != null
        && numberActiveLocations != null
        && numberNearbyLocations != null
      ),
      _openTransactionsSubscription = openTransactionsBloc.listen(_updateNumberOpenTransactions),
      _activeLocationSubscription = activeLocationBloc.listen(_updatenumberActiveLocations),
      _nearbyBusinessesSubscription = nearbByusinessesBloc.listen(_updatenumberNearbyBusinesses),
      super(LogoButtonsListState.initial(
        numberOpenTransactions: numberOpenTransactions,
        numberActiveLocations: numberActiveLocations,
        numberNearbyLocations: numberNearbyLocations
      ));

  @override
  Stream<LogoButtonsListState> mapEventToState(LogoButtonsListEvent event) async* {
    if (event is NumberOpenTransactionsChanged) {
      yield state.update(numberOpenTransactions: event.numberOpenTransactions);
    } else if (event is NumberActiveLocationsChanged) {
      yield state.update(numberActiveLocations: event.numberActiveLocations);
    } else if (event is NumberNearbyBusinessesChanged) {
      yield state.update(numberNearbyLocations: event.numberNearbyBusinesses);
    }
  }

  static void _updateNumberOpenTransactions(OpenTransactionsState state) {
    if (state is OpenTransactionsLoaded) {
      NumberOpenTransactionsChanged(numberOpenTransactions: state.openTransactions.length);
    }
  }

  static void _updatenumberActiveLocations(ActiveLocationState state) {
    if (state is CurrentActiveLocations) {
      NumberActiveLocationsChanged(numberActiveLocations: state.activeLocations.length);
    } else {
      NumberActiveLocationsChanged(numberActiveLocations: 0);
    }
  }

  static void _updatenumberNearbyBusinesses(NearbyBusinessesState state) {
    if (state is NearbyBusinessLoaded) {
      NumberNearbyBusinessesChanged(numberNearbyBusinesses: state.businesses.length);
    } else {
      NumberNearbyBusinessesChanged(numberNearbyBusinesses: 0);
    }
  }

  @override
  Future<void> close() {
    _openTransactionsSubscription.cancel();
    _activeLocationSubscription.cancel();
    _nearbyBusinessesSubscription.cancel();
    return super.close();
  }
}
