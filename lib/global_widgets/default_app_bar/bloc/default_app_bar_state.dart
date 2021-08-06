part of 'default_app_bar_bloc.dart';

@immutable
class DefaultAppBarState extends Equatable {
  final bool isRotated;

  DefaultAppBarState({required this.isRotated});

  factory DefaultAppBarState.initial() {
    return DefaultAppBarState(isRotated: false);
  }

  DefaultAppBarState update({required bool isRotated}) {
    return DefaultAppBarState(isRotated: isRotated);
  }

  @override
  List<Object> get props => [isRotated];

  @override
  String toString() => 'DefaultAppBarState { isRotated: $isRotated }';
}
