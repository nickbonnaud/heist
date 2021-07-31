import 'package:bloc/bloc.dart';

class BusinessScreenVisibleCubit extends Cubit<bool> {
  BusinessScreenVisibleCubit() : super(false);
  
  void toggle() => emit(!state);
}
