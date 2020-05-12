import 'package:heist/providers/storage_provider.dart';

class TutorialRepository {
  final StorageProvider _tutorialProvider = StorageProvider();
  static const String PERMISSIONS_KEY = 'permissions';
  static const String TUTORIAL_KEY = 'tutorial';

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

  Future<void> setShouldShowTutorial(bool shouldShow) async {
    return await _tutorialProvider.write(TUTORIAL_KEY, shouldShow.toString().toLowerCase());
  }

  Future<bool> showTutorial() async {
    String showTutorial = await _tutorialProvider.read(TUTORIAL_KEY);
    if (showTutorial.toString() == 'null') {
      setShouldShowTutorial(true);
      return true;
    } else {
      return showTutorial?.toLowerCase() == 'true';
    }

  }
}