import 'package:bloc/bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/models/status.dart';


enum OnboardEvent {next, prev}

class OnboardBloc extends Bloc<OnboardEvent, int> {
  
  OnboardBloc({required Status customerStatus, required int numberValidPermissions})
    : super(_setInitialStep(customerStatus: customerStatus, numberValidPermissions: numberValidPermissions)) {
      _eventHandler();
  }

  void _eventHandler() {
    on<OnboardEvent>((event, emit) => _mapOnboardEventToState(event: event, emit: emit));
  }

  void _mapOnboardEventToState({required OnboardEvent event, required Emitter<int> emit}) {
    if (event == OnboardEvent.next) {
      emit(state + 1);
    } else if (event == OnboardEvent.prev) {
      emit(state - 1);
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
