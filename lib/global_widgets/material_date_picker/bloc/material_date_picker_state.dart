
part of 'material_date_picker_bloc.dart';

@immutable
class MaterialDatePickerState extends Equatable {
  final DateTime? startDate;
  final DateTime endDate;
  final Active active;

  MaterialDatePickerState({
    required this.startDate,
    required this.endDate,
    required this.active
  });

  factory MaterialDatePickerState.initial() {
    return MaterialDatePickerState(
      startDate: null,
      endDate: DateTime.now(),
      active: Active.start
    );
  }

  MaterialDatePickerState update({
    DateTime? startDate,
    DateTime? endDate,
    Active? active
  }) => MaterialDatePickerState(
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    active: active ?? this.active
  );

  @override
  List<Object?> get props => [startDate, endDate, active];

  @override
  String toString() => 'MaterialDatePickerState { startDate: $startDate, endDate: $endDate, active: $active }';
}
