part of 'default_app_bar_bloc.dart';

@immutable
abstract class DefaultAppBarEvent {}


class Rotate extends DefaultAppBarEvent {}

class Reset extends DefaultAppBarEvent {}