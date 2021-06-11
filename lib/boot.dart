import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/routing/app_router.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/main_theme.dart';

class Boot extends StatelessWidget {
  final MaterialApp? _testApp;
  final AppRouter _router = AppRouter();

  Boot({MaterialApp? testApp})
    : _testApp = testApp;

  @override
  Widget build(BuildContext context) {
    return _testApp == null
      ? _app(context: context)
      : _testApp!;
  }

  PlatformProvider _app({required BuildContext context}) {
    return PlatformProvider(builder: (context) {
      SizeConfig().init(context);
      return MaterialApp(
        initialRoute: Routes.app,
        theme: MainTheme.themeData(context: context),
        title: Constants.appName,
        onGenerateRoute: (settings) => _router.goTo(context: context, settings: settings),
        localizationsDelegates: [
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
      );
    });
  }
}