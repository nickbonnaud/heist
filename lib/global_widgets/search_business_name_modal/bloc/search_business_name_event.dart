part of 'search_business_name_bloc.dart';

abstract class SearchBusinessNameEvent extends Equatable {
  const SearchBusinessNameEvent();

  @override
  List<Object> get props => [];
}

class BusinessNameChanged extends SearchBusinessNameEvent {
  final String name;

  const BusinessNameChanged({required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'BusinessNameChanged { name: $name }';
}

class Reset extends SearchBusinessNameEvent {}
