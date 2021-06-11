part of 'ios_date_picker_bloc.dart';

@immutable
class IosDatePickerState extends Equatable {
  final DateTime? startDate;
  final DateTime endDate;
  final Active active;

  IosDatePickerState({
    required this.startDate,
    required this.endDate,
    required this.active
  });

  factory IosDatePickerState.initial() {
    return IosDatePickerState(
      startDate: null,
      endDate: DateTime.now(),
      active: Active.start
    );
  }

  IosDatePickerState update({
    DateTime? startDate,
    DateTime? endDate,
    Active? active
  }) => IosDatePickerState(
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    active: active ?? this.active
  );

  @override
  List<Object?> get props => [startDate, endDate, active];

  @override
  String toString() => 'IosDatePickerState { startDate: $startDate, endDate: $endDate, active: $active }';
}

