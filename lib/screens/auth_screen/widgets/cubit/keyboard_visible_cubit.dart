import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class KeyboardVisibleCubit extends Cubit<bool> {
  KeyboardVisibleCubit() : super(false);
  
  void toggle({@required bool isVisible}) => emit(isVisible);
}
