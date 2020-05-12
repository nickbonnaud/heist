import 'package:heist/providers/storage_provider.dart';

class InitialLoginRepository {
  final StorageProvider _tutorialProvider = StorageProvider();
  static const String PERMISSIONS_KEY = 'permissions';

  Future<void> setIsInitialLogin(bool isInitial) async {
    return await _tutorialProvider.write(PERMISSIONS_KEY, isInitial.toString().toLowerCase());
  }

  Future<bool> isInitialLogin() async {
    String isInitial = await _tutorialProvider.read(PERMISSIONS_KEY);
    // setIsInitialLogin(true);
    if (isInitial.toString() == 'null') {
      setIsInitialLogin(true);
      return true;
    } else {
      return isInitial?.toLowerCase() == 'true';
    }
  }
}