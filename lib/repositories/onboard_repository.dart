import 'package:heist/providers/storage_provider.dart';

class OnboardRepository {
  final StorageProvider _onboardProvider = StorageProvider();
  static const String PERMISSIONS_KEY = 'permissions';
  static const String TUTORIAL_KEY = 'onboard';

  Future<void> setIsInitialLogin(bool isInitial) async {
    return await _onboardProvider.write(PERMISSIONS_KEY, isInitial.toString().toLowerCase());
  }

  Future<bool> isInitialLogin() async {
    String isInitial = await _onboardProvider.read(PERMISSIONS_KEY);
    // setIsInitialLogin(true);
    if (isInitial.toString() == 'null') {
      setIsInitialLogin(true);
      return true;
    } else {
      return isInitial?.toLowerCase() == 'true';
    }
  }

  Future<void> setShouldShowTutorial(bool shouldShow) async {
    return await _onboardProvider.write(TUTORIAL_KEY, shouldShow.toString().toLowerCase());
  }

  Future<bool> showTutorial() async {
    String showTutorial = await _onboardProvider.read(TUTORIAL_KEY);
    if (showTutorial.toString() == 'null') {
      setShouldShowTutorial(true);
      return true;
    } else {
      return showTutorial?.toLowerCase() == 'true';
    }

  }
}