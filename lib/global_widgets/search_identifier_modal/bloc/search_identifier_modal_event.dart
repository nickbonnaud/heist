part of 'search_identifier_modal_bloc.dart';

abstract class SearchIdentifierModalEvent extends Equatable {
  const SearchIdentifierModalEvent();

  @override
  List<Object> get props => [];
}

class UUIDChanged extends SearchIdentifierModalEvent {
  final String uuid;

  const UUIDChanged({required this.uuid});

  @override
  List<Object> get props => [uuid];

  @override
  String toString() => 'UUIDChanged { uuid: $uuid }';
}
