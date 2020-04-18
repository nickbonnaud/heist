part of 'material_date_picker_bloc.dart';

abstract class MaterialDatePickerEvent extends Equatable {
  const MaterialDatePickerEvent();

  @override
  List<Object> get props => [];
}

class DateChanged extends MaterialDatePickerEvent {
  final DateTime date;

  const DateChanged({@required this.date});

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'DateChanged { date: $date }';
}

class ActiveSelectionChanged extends MaterialDatePickerEvent {
  final Active active;

  const ActiveSelectionChanged({@required this.active});

  @override
  String toString() => 'ActiveSelectionChanged { active: $active }';
}

class Reset extends MaterialDatePickerEvent {}
