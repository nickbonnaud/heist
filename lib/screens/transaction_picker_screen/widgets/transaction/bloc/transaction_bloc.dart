import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';

class TransactionBloc extends Bloc<TransactionEvent, DateTime?> {
  TransactionBloc()
    : super(null) { _eventHandler(); }

  void _eventHandler() {
    on<PickerChanged>((event, emit) => _mapPickerChangedToState(event: event, emit: emit));
  }

  void _mapPickerChangedToState({required PickerChanged event, required Emitter<DateTime?> emit}) {
    emit(event.transactionUpdatedAt);
  }
}
