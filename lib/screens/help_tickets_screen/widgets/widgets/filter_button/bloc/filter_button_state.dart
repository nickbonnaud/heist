part of 'filter_button_bloc.dart';

@immutable
class FilterButtonState extends Equatable {
  final bool isActive;

  const FilterButtonState({required this.isActive});

  factory FilterButtonState.initial() {
    return const FilterButtonState(isActive: false);
  }

  FilterButtonState update({required bool isActive}) {
    return FilterButtonState(isActive: isActive);
  }

  @override
  List<Object> get props => [isActive];

  @override
  String toString() => 'FilterButtonState { isActive: $isActive }';
}
