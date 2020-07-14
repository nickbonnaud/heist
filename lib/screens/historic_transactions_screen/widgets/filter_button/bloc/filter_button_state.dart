part of 'filter_button_bloc.dart';

@immutable
class FilterButtonState {
  final bool isActive;

  FilterButtonState({@required this.isActive});

  factory FilterButtonState.initial() {
    return FilterButtonState(isActive: false);
  }

  FilterButtonState update({@required bool isActive}) {
    return FilterButtonState(isActive: isActive);
  }

  @override
  String toString() => 'FilterButtonState { isActive: $isActive }';
}
