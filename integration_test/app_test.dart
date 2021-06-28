import 'package:flutter_test/flutter_test.dart';
import 'package:heist/boot_phases/phase_one.dart';
import 'package:heist/screens/auth_screen/widgets/forms/widgets/login/login.dart';
import 'package:heist/screens/splash_screen/splash_screen.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Init App Tests", (tester) async {
    await tester.pumpWidget(PhaseOne());

    expect(find.byType(SplashScreen), findsOneWidget);

    while(!tester.any(find.byType(Login))) {
      await tester.pump();
    }

    expect(find.byType(Login), findsOneWidget);
  });
}