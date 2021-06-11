import 'package:bloc/bloc.dart';

class KeyboardVisibleCubit extends Cubit<bool> {
  KeyboardVisibleCubit() : super(false);
  
  void toggle({required bool isVisible}) => emit(isVisible);
}
