import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/home_screen/blocs/business_screen_visible_cubit.dart';

import 'blocs/side_drawer_bloc/side_drawer_bloc.dart';
import 'widgets/home_screen_body/home_screen_body.dart';
import 'widgets/side_drawer/side_drawer.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previousState, currentState) {
            return previousState is Authenticated && currentState is Unauthenticated;
          },
          listener: (context, state) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.auth, (route) => false);
          },
        ),
        BlocListener<NotificationNavigationBloc, NotificationNavigationState>(
          listenWhen: (previousState, currentState) {
            return previousState.route == null && currentState.route != null;
          },
          listener: (context, state) {
            if (BlocProvider.of<ReceiptModalSheetBloc>(context).isVisible) Navigator.of(context).pop();
            Navigator.of(context).pushNamed(state.route!, arguments: state.arguments);
            BlocProvider.of<NotificationNavigationBloc>(context).add(ResetFromNotification());
          }
        )
      ],
      child: Scaffold(
        key: const Key("homeScreenKey"),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<SideDrawerBloc>(
              create: (_) => SideDrawerBloc()
            ),
            
            BlocProvider<BusinessScreenVisibleCubit>(
              create: (_) => BusinessScreenVisibleCubit()
            ),
          ],
          child: const SideDrawer(
            homeScreen: HomeScreenBody(),
          ),
        )
      )
    );
  }
}