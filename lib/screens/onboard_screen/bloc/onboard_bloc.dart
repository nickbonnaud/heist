import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:meta/meta.dart';


enum OnboardEvent {next, prev}

class OnboardBloc extends Bloc<OnboardEvent, int> {
  
  OnboardBloc({@required AuthenticationBloc authenticationBloc, @required PermissionsBloc permissionsBloc})
    : assert(authenticationBloc != null && permissionsBloc != null),
      super(_setInitialStep(authenticationBloc: authenticationBloc, permissionsBloc: permissionsBloc));

  @override
  Stream<int> mapEventToState(OnboardEvent event) async* {
    if (event == OnboardEvent.next) {
      yield state + 1;
    } else if (event == OnboardEvent.prev) {
      yield state - 1;
    }
  }

  static int _setInitialStep({@required AuthenticationBloc authenticationBloc, @required PermissionsBloc permissionsBloc}) {
    if (authenticationBloc.customer.status.code == 100) return 0; 

    if (authenticationBloc.customer.status.code > 100 && authenticationBloc.customer.status.code <= 103) return 1;

    if (permissionsBloc.numberValidPermissions < PermissionType.values.length) {
      return permissionsBloc.numberValidPermissions == 0 ? 2 : 3;
    }
    return 0;
  }
}
