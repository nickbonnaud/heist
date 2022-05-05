part of 'search_identifier_modal_bloc.dart';

@immutable
class SearchIdentifierModalState extends Equatable {
  final bool isUUIDValid;
  final String uuid;

  bool get isFieldValid => isUUIDValid && uuid.isNotEmpty;

  const SearchIdentifierModalState({required this.isUUIDValid, required this.uuid});

  factory SearchIdentifierModalState.initial() {
    return const SearchIdentifierModalState(isUUIDValid: false, uuid: '');
  }

  SearchIdentifierModalState update({bool? isUUIDValid, String? uuid}) {
    return SearchIdentifierModalState(
      isUUIDValid: isUUIDValid ?? this.isUUIDValid,
      uuid: uuid ?? this.uuid
    );
  }
  
  @override
  List<Object> get props => [isUUIDValid, uuid];

  @override
  String toString() => 'SearchIdentifierModalState { isUUIDValid: $isUUIDValid, uuid: $uuid }';
}
