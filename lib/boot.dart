import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/routing/app_router.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/main_theme.dart';

class Boot extends StatelessWidget {
  final PlatformProvider? _testApp;
  final AppRouter _router = AppRouter();

  Boot({PlatformProvider? testApp})
    : _testApp = testApp;

  @override
  Widget build(BuildContext context) {
    return _testApp == null
      ? _app(context: context)
      : _testApp!;
  }

  Theme _app({required BuildContext context}) {
    return Theme(
      data: MainTheme.themeData(context: context),
      child: PlatformProvider(
        builder: (context) {
          return PlatformApp(
            initialRoute: Routes.app,
            title: Constants.appName,
            onGenerateRoute: (settings) => _router.goTo(context: context, settings: settings),
            localizationsDelegates: [
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultMaterialLocalizations.delegate,
            ],
          );
        }
      )
    );
  }
}