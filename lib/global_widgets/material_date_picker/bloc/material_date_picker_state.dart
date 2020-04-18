
part of 'material_date_picker_bloc.dart';

@immutable
class MaterialDatePickerState {
  final DateTime startDate;
  final DateTime endDate;
  final Active active;

  MaterialDatePickerState({
    @required this.startDate,
    @required this.endDate,
    @required this.active
  });

  factory MaterialDatePickerState.initial() {
    return MaterialDatePickerState(
      startDate: null,
      endDate: DateTime.now(),
      active: Active.start
    );
  }

  MaterialDatePickerState update({
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
  
  MaterialDatePickerState _copyWith({
    DateTime startDate,
    DateTime endDate,
    Active active
  }) {
    return MaterialDatePickerState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      active: active ?? this.active
    );
  }
}
