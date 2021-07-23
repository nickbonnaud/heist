import 'package:flutter_test/flutter_test.dart';
import 'package:heist/boot_phases/phase_one.dart';
import 'package:integration_test/integration_test.dart';

import 'screens/home_screen_test.dart';
import 'screens/onboard_screen_test.dart';
import 'screens/register_screen_test.dart';
import 'screens/splash_screen_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets("Init App Tests", (tester) async {
    await tester.pumpWidget(PhaseOne(testing: true));

    await SplashScreenTest(tester: tester).init();
    await RegisterScreenTest(tester: tester).init();
    await OnboardScreenTest(tester: tester).init();
    await HomeScreenTest(tester: tester).init();
    // await RequestResetPasswordScreenTest(tester: tester).init();
    // await ResetPasswordScreenTest(tester: tester).init();
    // await LoginScreenTest(tester: tester).init();
  });
}