import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/routing/app_router.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/main_theme.dart';

class Boot extends StatelessWidget {
  final AppRouter _router = const AppRouter();

  const Boot({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        theme: MainTheme.themeData(context: context),
        initialRoute: Routes.app,
        title: Constants.appName,
        onGenerateRoute: (settings) => _router.goTo(context: context, settings: settings),
        localizationsDelegates: const [
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
      )
    );
  }
}