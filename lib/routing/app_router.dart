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
import 'package:heist/global_widgets/route_builders/overlay_route.dart';
import 'package:heist/global_widgets/route_builders/slide_up_route.dart';
import 'package:heist/global_widgets/search_business_name_modal/search_business_name_modal.dart';
import 'package:heist/global_widgets/search_identifier_modal/search_identifier_modal.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/reset_password_args.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/providers/account_provider.dart';
import 'package:heist/providers/authentication_provider.dart';
import 'package:heist/providers/business_provider.dart';
import 'package:heist/providers/customer_provider.dart';
import 'package:heist/providers/geolocator_provider.dart';
import 'package:heist/providers/help_provider.dart';
import 'package:heist/providers/photo_picker_provider.dart';
import 'package:heist/providers/photo_provider.dart';
import 'package:heist/providers/profile_provider.dart';
import 'package:heist/providers/refund_provider.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/providers/transaction_issue_provider.dart';
import 'package:heist/providers/transaction_provider.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/geolocator_repository.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/repositories/refund_repository.dart';
import 'package:heist/repositories/token_repository.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/app/app.dart';
import 'package:heist/screens/auth_screen/auth_screen.dart';
import 'package:heist/screens/business_screen/business_screen.dart';
import 'package:heist/screens/email_screen/email_screen.dart';
import 'package:heist/screens/help_ticket_screen/help_ticket_screen.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/screens/help_tickets_screen/help_tickets_screen.dart';
import 'package:heist/screens/help_tickets_screen/models/help_ticket_args.dart';
import 'package:heist/screens/help_tickets_screen/widgets/widgets/new_help_ticket_screen/new_help_ticket_screen.dart';
import 'package:heist/screens/historic_transactions_screen/historic_transactions_screen.dart';
import 'package:heist/screens/home_screen/home_screen.dart';
import 'package:heist/screens/issue_screen/issue_screen.dart';
import 'package:heist/screens/issue_screen/models/issue_args.dart';
import 'package:heist/screens/onboard_screen/onboard_screen.dart';
import 'package:heist/screens/password_screen/password_screen.dart';
import 'package:heist/screens/permissions_screen/permissions_screen.dart';
import 'package:heist/screens/profile_screen/profile_screen.dart';
import 'package:heist/screens/profile_setup_screen/profile_setup_screen.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:heist/screens/refunds_screen/refunds_screen.dart';
import 'package:heist/screens/request_reset_password_screen/request_reset_password_screen.dart';
import 'package:heist/screens/reset_password_screen/reset_password_screen.dart';
import 'package:heist/screens/settings_screen/settings_screen.dart';
import 'package:heist/screens/sign_out_screen/sign_out_screen.dart';
import 'package:heist/screens/tip_screen/tip_screen.dart';
import 'package:heist/screens/tutorial_screen/tutorial_screen.dart';

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
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context)
          ),
          name: routeData.route,
          transitionDuration: Duration(seconds: 1)
        );
        break;
      case Routes.onboard:
        route = SlideUpRoute(
          screen: OnboardScreen(
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context),
            customerBloc: BlocProvider.of<CustomerBloc>(context),
          ),
          name: routeData.route
        );
        break;
      case Routes.home:
        route = SlideUpRoute(
          screen: HomeScreen(
            geoLocationBloc: GeoLocationBloc(
              geolocatorRepository: GeolocatorRepository(
                geolocatorProvider: GeolocatorProvider()
              ), 
              permissionsBloc: BlocProvider.of<PermissionsBloc>(context)
            ),
            nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context)
          ),
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
        route = OverlayRouteTest(screen: BusinessScreen(business: routeData.args as Business), name: routeData.route);
        break;
      case Routes.requestReset:
        route = _createFullScreenDialogRoute(
          screen: RequestResetPasswordScreen(authenticationRepository: AuthenticationRepository(authenticationProvider: AuthenticationProvider(), tokenRepository: TokenRepository(tokenProvider: StorageProvider()))),
          name: routeData.route
        );
        break;
      case Routes.resetPassword:
        route = _createRouteDefault(
          screen: ResetPasswordScreen(
            authenticationRepository: AuthenticationRepository(authenticationProvider: AuthenticationProvider(), tokenRepository: TokenRepository(tokenProvider: StorageProvider())), 
            resetPasswordArgs: routeData.args as ResetPasswordArgs
          ),
          name: routeData.route
        );
        break;
      case Routes.onboardProfile:
        route = _createFullScreenDialogRoute(
          screen: ProfileSetupScreen(
            customerBloc: BlocProvider.of<CustomerBloc>(context),
            profileRepository: ProfileRepository(profileProvider: ProfileProvider()),
            photoRepository: PhotoRepository(photoProvider: PhotoProvider()),
            accountRepository: AccountRepository(accountProvider: AccountProvider()),
            photoPickerRepository: PhotoPickerRepository(photoPickerProvder: PhotoPickerProvder())
          ),
          name: routeData.route
        );
        break;
      case Routes.tutorial:
        route = _createFullScreenDialogRoute(
          screen: TutorialScreen(),
          name: routeData.route
        );
        break;
      case Routes.onboardPermissions:
        route = _createFullScreenDialogRoute(
          screen: PermissionsScreen(
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context),
            geoLocationBloc: BlocProvider.of<GeoLocationBloc>(context),
            initialLoginRepository: InitialLoginRepository(tutorialProvider: StorageProvider()),
            customerIdentifier: BlocProvider.of<CustomerBloc>(context).customer!.identifier
          ),
          name: routeData.route
        );
        break;
      case Routes.transactions:
        route = _createRouteDefault(
          screen: HistoricTransactionsScreen(
            transactionRepository: TransactionRepository(transactionProvider: TransactionProvider()),
          ),
          name: routeData.route
        );
        break;
      case Routes.transactionsBusinessName:
        route = _createFullScreenDialogRoute(
          screen: SearchBusinessNameModal(
            businessRepository: BusinessRepository(businessProvider: BusinessProvider()),
          ),
          name: routeData.route
        );
        break;
      case Routes.transactionsIdentifier:
        route = _createFullScreenDialogRoute(
          screen: SearchIdentifierModal(
            hintText: "Transaction ID"
          ),
          name: routeData.route
        );
        break;
      case Routes.refunds:
        route = _createRouteDefault(
          screen: RefundsScreen(
            refundRepository: RefundRepository(refundProvider: RefundProvider())
          ),
          name: routeData.route
        );
        break;
      case Routes.refundsBusinessName:
        route = _createFullScreenDialogRoute(
          screen: SearchBusinessNameModal(
            businessRepository: BusinessRepository(businessProvider: BusinessProvider()),
          ),
          name: routeData.route
        );
        break;
      case Routes.refundsTransactionIdentifier:
        route = _createFullScreenDialogRoute(
          screen: SearchIdentifierModal(
            hintText: "Transaction ID"
          ),
          name: routeData.route
        );
        break;
      case Routes.refundsIdentifier:
        route = _createFullScreenDialogRoute(
          screen: SearchIdentifierModal(
            hintText: "Refund ID"
          ),
          name: routeData.route
        );
        break;
      case Routes.settings:
        route = _createRouteDefault(
          screen: SettingsScreen(), 
          name: routeData.route
        );
        break;
      case Routes.profile:
        route = _createFullScreenDialogRoute(
          screen: ProfileScreen(
            profileRepository: ProfileRepository(profileProvider: ProfileProvider()),
            photoRepository: PhotoRepository(photoProvider: PhotoProvider()),
            profile: BlocProvider.of<CustomerBloc>(context).customer!.profile,
            photoPickerRepository: PhotoPickerRepository(photoPickerProvder: PhotoPickerProvder()),
            customerBloc: BlocProvider.of<CustomerBloc>(context)
          ),
          name: routeData.route
        );
        break;
      case Routes.email:
        route = _createFullScreenDialogRoute(
          screen: EmailScreen(
            customerRepository: CustomerRepository(
              customerProvider: CustomerProvider(), 
              tokenRepository: TokenRepository(tokenProvider: StorageProvider())
            ),
            customerBloc: BlocProvider.of<CustomerBloc>(context)
          ),
          name: routeData.route
        );
        break;
      case Routes.password:
        route = _createFullScreenDialogRoute(
          screen: PasswordScreen(
            customerRepository: CustomerRepository(
              customerProvider: CustomerProvider(), 
              tokenRepository: TokenRepository(tokenProvider: StorageProvider())
            ),
            authenticationRepository: AuthenticationRepository(
              authenticationProvider: AuthenticationProvider(),
              tokenRepository: TokenRepository(tokenProvider: StorageProvider())
            ),
            customerBloc: BlocProvider.of<CustomerBloc>(context)
          ),
          name: routeData.route
        );
        break;
      case Routes.tips:
        route = _createFullScreenDialogRoute(
          screen: TipScreen(
            accountRepository: AccountRepository(accountProvider: AccountProvider()),
            customerBloc: BlocProvider.of<CustomerBloc>(context)
          ),
          name: routeData.route
        );
        break;
      case Routes.logout:
        route = _createFullScreenDialogRoute(
          screen: SignOutScreen(
            authenticationRepository: AuthenticationRepository(
              authenticationProvider: AuthenticationProvider(),
              tokenRepository: TokenRepository(tokenProvider: StorageProvider())
            ),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)
          ),
          name: routeData.route
        );
        break;
      case Routes.helpTickets:
        route = _createRouteDefault(
          screen: HelpTicketsScreen(
            helpRepository: HelpRepository(helpProvider: HelpProvider())
          ),
          name: routeData.route
        );
        break;
      case Routes.helpTicketDetails:
        route = _createFullScreenDialogRoute(
          screen: HelpTicketScreen(
            helpRepository: HelpRepository(helpProvider: HelpProvider()),
            helpTicket: (routeData.args as HelpTicketArgs).helpTicket,
            helpTicketsScreenBloc: (routeData.args as HelpTicketArgs).helpTicketsScreenBloc
          ),
          name: routeData.route
        );
        break;
      case Routes.helpTicketNew:
        route = _createFullScreenDialogRoute(
          screen: NewHelpTicketScreen(
            helpRepository: HelpRepository(helpProvider: HelpProvider()),
            helpTicketsScreenBloc: routeData.args as HelpTicketsScreenBloc
          ),
          name: routeData.route
        );
        break;
      case Routes.reportIssue:
        IssueArgs issueArgs = routeData.args as IssueArgs;
        route = _createFullScreenDialogRoute(
          screen: IssueScreen(
            issueRepository: TransactionIssueRepository(issueProvider: TransactionIssueProvider()),
            type: issueArgs.type,
            transaction: issueArgs.transactionResource
          ),
          name: routeData.route
        );
        break;
      default:
        route = SlideUpRoute(
          screen: HomeScreen(
            geoLocationBloc: GeoLocationBloc(
              geolocatorRepository: GeolocatorRepository(
                geolocatorProvider: GeolocatorProvider()
              ), 
              permissionsBloc: BlocProvider.of<PermissionsBloc>(context)
            ),
            nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context)
          ),
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