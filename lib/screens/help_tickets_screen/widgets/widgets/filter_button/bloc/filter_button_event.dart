part of 'filter_button_bloc.dart';

abstract class FilterButtonEvent extends Equatable {
  const FilterButtonEvent();

  @override
  List<Object> get props => [];
}

class Toggle extends FilterButtonEvent {}