import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/global_widgets/route_builders/fade_in_route.dart';
import 'package:heist/global_widgets/route_builders/slide_up_route.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/providers/account_provider.dart';
import 'package:heist/providers/authentication_provider.dart';
import 'package:heist/providers/photo_picker_provider.dart';
import 'package:heist/providers/photo_provider.dart';
import 'package:heist/providers/profile_provider.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/providers/transaction_issue_provider.dart';
import 'package:heist/providers/transaction_provider.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/repositories/token_repository.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/screens/app/app.dart';
import 'package:heist/screens/auth_screen/auth_screen.dart';
import 'package:heist/screens/business_screen/business_screen.dart';
import 'package:heist/screens/layout_screen/layout_screen.dart';
import 'package:heist/screens/onboard_screen/onboard_screen.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';

import 'route_data.dart';
import 'routes.dart';

class AppRouter {
  
  Route goTo({required BuildContext context, required RouteSettings settings}) {
    final RouteData routeData = RouteData.init(settings: settings);
    Route route;

    switch (routeData.route) {
      case Routes.app:
        route = _createRouteDefault(screen: App(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
          beaconBloc: BlocProvider.of<BeaconBloc>(context),
          nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
          permissionsBloc: BlocProvider.of<PermissionsBloc>(context),
          customerBloc: BlocProvider.of<CustomerBloc>(context),
        ), 
        name: routeData.route);
        break;
      case Routes.auth:
        route = FadeInRoute(
          screen: AuthScreen(
            authenticationRepository: AuthenticationRepository(
              tokenRepository: TokenRepository(tokenProvider: StorageProvider()),
              authenticationProvider: AuthenticationProvider(),
            ),
            permissionsReady: BlocProvider.of<PermissionsBloc>(context).allPermissionsValid,
            customerOnboarded: BlocProvider.of<CustomerBloc>(context).customer!.status.code > 103,
          ),
          name: routeData.route,
          transitionDuration: Duration(seconds: 1)
        );
        break;
      case Routes.onboard:
        route = SlideUpRoute(
          screen: OnboardScreen(
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context),
            initialLoginRepository: InitialLoginRepository(tutorialProvider: StorageProvider()),
            geoLocationBloc: BlocProvider.of<GeoLocationBloc>(context),
            customerBloc: BlocProvider.of<CustomerBloc>(context),
            photoPickerRepository: PhotoPickerRepository(photoPickerProvder: PhotoPickerProvder()),
            accountRepository: AccountRepository(accountProvider: AccountProvider()),
            profileRepository: ProfileRepository(profileProvider: ProfileProvider()),
            photoRepository: PhotoRepository(photoProvider: PhotoProvider()),
          ),
          name: routeData.route
        );
        break;
      case Routes.layout:
        route = SlideUpRoute(
          screen: LayoutScreen(),
          name: routeData.route
        );
        break;
      case Routes.receipt:
        route = _createFullScreenDialogRoute(
          screen: ReceiptScreen(
            transactionResource: routeData.args as TransactionResource,
            receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context),
            transactionRepository: TransactionRepository(transactionProvider: TransactionProvider()),
            transactionIssueRepository: TransactionIssueRepository(issueProvider: TransactionIssueProvider()),
            openTransactionsBloc: OpenTransactionsBloc(transactionRepository: TransactionRepository(transactionProvider: TransactionProvider()), authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))
          ),
          name: routeData.route
        );
        break;
      case Routes.business:
        route = _createFullScreenDialogRoute(
          screen: BusinessScreen(business: routeData.args as Business),
          name: routeData.route
        );
        break;
      default:
        route = route = SlideUpRoute(
          screen: LayoutScreen(),
          name: routeData.route
        );
    }
    return route;
  }

  MaterialPageRoute _createRouteDefault({required Widget screen, required String name}) {
    return MaterialPageRoute(
      builder: (_) => screen,
      settings: RouteSettings(name: name)
    );
  }

  MaterialPageRoute _createFullScreenDialogRoute({required Widget screen, required String name}) {
    return MaterialPageRoute(
      builder: (context) => screen,
      fullscreenDialog: true,
      settings: RouteSettings(name: name)
    );
  }
}