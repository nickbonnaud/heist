import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/models/status.dart';


enum OnboardEvent {next, prev}

class OnboardBloc extends Bloc<OnboardEvent, int> {
  
  OnboardBloc({required Status customerStatus, required int numberValidPermissions})
    : super(_setInitialStep(customerStatus: customerStatus, numberValidPermissions: numberValidPermissions));

  @override
  Stream<int> mapEventToState(OnboardEvent event) async* {
    if (event == OnboardEvent.next) {
      yield state + 1;
    } else if (event == OnboardEvent.prev) {
      yield state - 1;
    }
  }

  static int _setInitialStep({required Status customerStatus, required int numberValidPermissions}) {
    if (customerStatus.code == 100) return 0; 

    if (customerStatus.code > 100 && customerStatus.code <= 103) return 1;

    if (numberValidPermissions < PermissionType.values.length) {
      return numberValidPermissions == 0 ? 2 : 3;
    }
    return 0;
  }
}
