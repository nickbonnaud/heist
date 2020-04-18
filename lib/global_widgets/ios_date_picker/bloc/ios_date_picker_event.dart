part of 'ios_date_picker_bloc.dart';

abstract class IosDatePickerEvent extends Equatable {
  const IosDatePickerEvent();

  @override
  List<Object> get props => [];
}

class DateChanged extends IosDatePickerEvent {
  final DateTime date;

  const DateChanged({@required this.date});

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'DateChanged { date: $date }';
}

class ActiveSelectionChanged extends IosDatePickerEvent {
  final Active active;

  const ActiveSelectionChanged({@required this.active});

  @override
  String toString() => 'ActiveSelectionChanged { active: $active }';
}

class Reset extends IosDatePickerEvent {}
