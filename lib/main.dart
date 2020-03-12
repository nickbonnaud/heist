import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/home_screen.dart';
import 'package:heist/screens/splash_screen.dart';
import 'package:heist/themes/default_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final CustomerRepository customerRepository = CustomerRepository();
  
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: SystemUiOverlayStyle.dark.systemNavigationBarColor
    )
  );
  
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(customerRepository: customerRepository)
        ..add(AppStarted()),
      child: App(customerRepository: customerRepository),
    )
  );
}

class App extends StatelessWidget {
  final CustomerRepository _customerRepository;

  App({Key key, @required CustomerRepository customerRepository})
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      super(key: key);

  final materialTheme = new ThemeData(
    primarySwatch: Colors.purple,
  );

  final materialDarkTheme = new ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
  );

  final cupertinoTheme = new CupertinoThemeData(
    brightness: null,
    primaryColor: CupertinoDynamicColor.withBrightness(
      color: Colors.purple,
      darkColor: Colors.cyan,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: defaultTheme,
      child: PlatformProvider(
        builder: (context) => PlatformApp(
          title: Constants.appName,
          android: (_) {
            return new MaterialAppData(
              theme: materialTheme,
              darkTheme: materialDarkTheme,
              themeMode: ThemeMode.system
            );
          },
          ios: (_) => new CupertinoAppData(
            theme: cupertinoTheme
          ),
          home: HomeScreen(),
        )
      )
    );
  }
}