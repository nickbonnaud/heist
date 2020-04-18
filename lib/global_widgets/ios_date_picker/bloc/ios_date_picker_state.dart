part of 'ios_date_picker_bloc.dart';

class IosDatePickerState {
  final DateTime startDate;
  final DateTime endDate;
  final Active active;

  IosDatePickerState({
    @required this.startDate,
    @required this.endDate,
    @required this.active
  });

  factory IosDatePickerState.initial() {
    return IosDatePickerState(
      startDate: null,
      endDate: DateTime.now(),
      active: Active.start
    );
  }

  IosDatePickerState update({
    DateTime startDate,
    DateTime endDate,
    Active active
  }) {
    return _copyWith(
      startDate: startDate,
      endDate: endDate,
      active: active
    );
  }
  
  IosDatePickerState _copyWith({
    DateTime startDate,
    DateTime endDate,
    Active active
  }) {
    return IosDatePickerState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      active: active ?? this.active
    );
  }
}

