import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/app.dart';
import 'package:heist/screens/login_screen/login_screen.dart';
import 'package:heist/screens/splash_screen.dart';

class Boot extends StatelessWidget {
  final CustomerRepository _customerRepository = CustomerRepository();
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (!state.authenticated && !state.loading) {
          Future.delayed(
            Duration(milliseconds: 500),
            () => showPlatformModalSheet(context: context, builder: (_) => LoginScreen(customerRepository: _customerRepository))
          );
        }

        if (state.authenticated) {
          BlocProvider.of<BootBloc>(context).add(CustomerStatusChanged(customerStatus: BlocProvider.of<AuthenticationBloc>(context).customer.status));
          BlocProvider.of<OpenTransactionsBloc>(context).add(FetchOpenTransactions());
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.authenticated) {
            return App();
          } else {
            return SplashScreen(shouldAnimate: false);
          }
        }
      )
    );
  }
}