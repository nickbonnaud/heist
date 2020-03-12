import 'package:heist/providers/storage_provider.dart';

class OnBoardRepository {
  final StorageProvider _onBoardProvider = StorageProvider();
  static const String PERMISSIONS_KEY = 'permissions';
  static const String ONBOARD_KEY = 'onboard';

  Future<void> setIsInitialLogin(bool isInitial) async {
    return await _onBoardProvider.write(PERMISSIONS_KEY, isInitial.toString().toLowerCase());
  }

  Future<bool> isInitialLogin() async {
    String isInitial = await _onBoardProvider.read(PERMISSIONS_KEY);
    if (isInitial.toString() == 'null') {
      setIsInitialLogin(true);
      return true;
    } else {
      return (isInitial?.toLowerCase() == 'true');
    }
  }
}