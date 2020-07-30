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
  final OpenTransactionsBloc openTransactionsBloc;
  final ActiveLocationBloc activeLocationBloc;
  final NearbyBusinessesBloc nearbyBusinessesBloc;
  StreamSubscription openTransactionsSubscription;
  StreamSubscription activeLocationSubscription;
  StreamSubscription nearbyBusinessesSubscription;

  
  LogoButtonsListBloc({
    @required this.openTransactionsBloc, 
    @required this.activeLocationBloc, 
    @required this.nearbyBusinessesBloc,
    @required int numberOpenTransactions,
    @required int numberActiveLocations,
    @required int numberNearbyLocations
  }) : super(LogoButtonsListState.initial(
      numberOpenTransactions: numberOpenTransactions,
      numberActiveLocations: numberActiveLocations,
      numberNearbyLocations: numberNearbyLocations
    )) {
      openTransactionsSubscription = openTransactionsBloc.listen((OpenTransactionsState state) {
        if (state is OpenTransactionsLoaded) {
          add(NumberOpenTransactionsChanged(numberOpenTransactions: state.openTransactions.length));
        }
      });

      activeLocationSubscription = activeLocationBloc.listen((ActiveLocationState state) {
        if (state is CurrentActiveLocations) {
          add(NumberActiveLocationsChanged(numberActiveLocations: state.activeLocations.length));
        } else {
          add(NumberActiveLocationsChanged(numberActiveLocations: 0));
        }
      });

      nearbyBusinessesSubscription = nearbyBusinessesBloc.listen((NearbyBusinessesState state) {
        if (state is NearbyBusinessLoaded) {
          add(NumberNearbyBusinessesChanged(numberNearbyBusinesses: state.businesses.length));
        } else {
          add(NumberNearbyBusinessesChanged(numberNearbyBusinesses: 0));
        }
      });
  }

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

  @override
  Future<void> close() {
    openTransactionsSubscription.cancel();
    activeLocationSubscription.cancel();
    nearbyBusinessesSubscription.cancel();
    return super.close();
  }
}
