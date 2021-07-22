import 'package:bloc/bloc.dart';

class IsTestingCubit extends Cubit<bool> {
  IsTestingCubit({bool testing: false}) : super(testing);
}
