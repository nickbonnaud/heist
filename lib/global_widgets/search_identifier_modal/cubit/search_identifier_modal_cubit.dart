import 'package:bloc/bloc.dart';
import 'package:heist/resources/helpers/validators.dart';

class SearchIdentifierModalCubit extends Cubit<bool> {
  SearchIdentifierModalCubit() : super(true);

  void inputChanged({required String uuid}) => emit(Validators.isValidUUID(uuid: uuid));
}
