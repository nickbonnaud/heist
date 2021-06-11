import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class DateRange extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({required this.startDate, required this.endDate});

  @override
  List<Object> get props => [startDate, endDate];

  @override
  String toString() => 'DateRange { startDate: $startDate, endDate: $endDate }';
}