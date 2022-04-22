import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/app/app.dart';
import 'package:heist/global_widgets/route_builders/fade_in_route.dart';
import 'package:heist/global_widgets/route_builders/overlay_route.dart';
import 'package:heist/global_widgets/route_builders/slide_up_route.dart';
import 'package:heist/global_widgets/search_business_name_modal/search_business_name_modal.dart';
import 'package:heist/global_widgets/search_identifier_modal/search_identifier_modal.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/reset_password_args.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/repositories/refund_repository.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/screens/auth_screen/auth_screen.dart';
import 'package:heist/screens/business_screen/business_screen.dart';
import 'package:heist/screens/email_screen/email_screen.dart';
import 'package:heist/screens/help_tickets_screen/help_tickets_screen.dart';
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
import 'package:heist/screens/transaction_business_picker_screen/transaction_business_picker_screen.dart';
import 'package:heist/screens/transaction_picker_screen/models/transaction_picker_args.dart';
import 'package:heist/screens/transaction_picker_screen/transaction_picker_screen.dart';
import 'package:heist/screens/tutorial_screen/tutorial_screen.dart';

import 'route_data.dart';
import 'routes.dart';

class AppRouter {
  
  const AppRouter();
  
  Route goTo({required BuildContext context, required RouteSettings settings}) {
    final RouteData routeData = RouteData.init(settings: settings);
    Route route;

    switch (routeData.route) {
      case Routes.app:
        route = _createRouteDefault(
          screen: const App(), 
        
        name: routeData.route);
        break;
      case Routes.auth:
        route = FadeInRoute(
          screen: RepositoryProvider(
            create: (_) => const AuthenticationRepository(),
            child: const AuthScreen(),
          ),

        name: routeData.route,
        transitionDuration: const Duration(seconds: 1));
        break;
      case Routes.onboard:
        route = SlideUpRoute(
          screen: const OnboardScreen(),
          
        name: routeData.route);
        break;
      case Routes.home:
        route = SlideUpRoute(
          screen: const HomeScreen(),
        
        name: routeData.route);
        break;
      case Routes.receipt:
        route = _createFullScreenDialogRoute(
          screen: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (_) => const TransactionRepository()
              ),

              RepositoryProvider(
                create: (_) => const TransactionIssueRepository()
              )
            ],
            child: ReceiptScreen(transactionResource: routeData.args as TransactionResource)
          ),

        name: routeData.route);
        break;
      case Routes.business:
        route = OverlayRouteApp(
          screen: BusinessScreen(business: routeData.args as Business),
          
        name: routeData.route);
        break;
      case Routes.transactionBusinessPicker:
        route = _createRouteDefault(
          screen: TransactionBusinessPickerScreen(availableBusinesses: routeData.args as List<Business>),
        
        name: routeData.route);
        break;
      case Routes.transactionPicker:
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const TransactionRepository(),
            child: TransactionPickerScreen(
              business: (routeData.args as TransactionPickerArgs).business,
              fromSettings: (routeData.args as TransactionPickerArgs).fromSettings,
            ),
          ),

        name: routeData.route);
        break;
      case Routes.requestReset:
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const AuthenticationRepository(),
            child: const RequestResetPasswordScreen(),
          ),
          
        name: routeData.route);
        break;
      case Routes.resetPassword:
        route = _createRouteDefault(
          screen: RepositoryProvider(
            create: (_) => const AuthenticationRepository(),
            child: ResetPasswordScreen(resetPasswordArgs: routeData.args as ResetPasswordArgs),
          ),
        
        name: routeData.route);
        break;
      case Routes.onboardProfile:
        route = _createFullScreenDialogRoute(
          screen: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (_) => const ProfileRepository()
              ),

              RepositoryProvider(
                create: (_) => const PhotoRepository()
              ),

              RepositoryProvider(
                create: (_) => const AccountRepository()
              ),

              RepositoryProvider(
                create: (_) => const PhotoPickerRepository()
              ),
            ],
            child: const ProfileSetupScreen()
          ),

        name: routeData.route);
        break;
      case Routes.tutorial:
        route = _createFullScreenDialogRoute(
          screen: const TutorialScreen(),
          
        name: routeData.route);
        break;
      case Routes.onboardPermissions:
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const InitialLoginRepository(),
            child: const PermissionsScreen(),
          ),

        name: routeData.route);
        break;
      case Routes.transactions:
        route = _createRouteDefault(
          screen: RepositoryProvider(
            create: (_) => const TransactionRepository(),
            child: const HistoricTransactionsScreen()
          ),
          
        name: routeData.route);
        break;
      case Routes.transactionsBusinessName:
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const BusinessRepository(),
            child: const SearchBusinessNameModal(),
          ),
          
        name: routeData.route);
        break;
      case Routes.transactionsIdentifier:
        route = _createFullScreenDialogRoute(
          screen: const SearchIdentifierModal(
            hintText: "Transaction ID"
          ),

        name: routeData.route);
        break;
      case Routes.refunds:
        route = _createRouteDefault(
          screen: RepositoryProvider(
            create: (_) => const RefundRepository(),
            child: const RefundsScreen()
          ),
          
        name: routeData.route);
        break;
      case Routes.refundsBusinessName:
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const BusinessRepository(),
            child: const SearchBusinessNameModal()
          ),

        name: routeData.route);
        break;
      case Routes.refundsTransactionIdentifier:
        route = _createFullScreenDialogRoute(
          screen: const SearchIdentifierModal(
            hintText: "Transaction ID"
          ),

        name: routeData.route);
        break;
      case Routes.refundsIdentifier:
        route = _createFullScreenDialogRoute(
          screen: const SearchIdentifierModal(
            hintText: "Refund ID"
          ),

        name: routeData.route);
        break;
      case Routes.settings:
        route = _createRouteDefault(
          screen: const SettingsScreen(), 
          
        name: routeData.route);
        break;
      case Routes.profile:
        route = _createFullScreenDialogRoute(
          screen: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (_) => const ProfileRepository()
              ),

              RepositoryProvider(
                create: (_) => const PhotoRepository()
              ),

              RepositoryProvider(
                create: (_) => const PhotoPickerRepository()
              ),
            ],
            child: const ProfileScreen()
          ),
          
        name: routeData.route);
        break;
      case Routes.email:
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const CustomerRepository(),
            child: const EmailScreen(),
          ),
        
        name: routeData.route);
        break;
      case Routes.password:
        route = _createFullScreenDialogRoute(
          screen: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (_) => const CustomerRepository(),
              ),

              RepositoryProvider(
                create: (_) => const AuthenticationRepository(),
              )
            ],
            child: const PasswordScreen()
          ),
          
        name: routeData.route);
        break;
      case Routes.tips:
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const AccountRepository(),
            child: const TipScreen(),
          ),
        
        name: routeData.route);
        break;
      case Routes.logout:
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const AuthenticationRepository(),
            child: const SignOutScreen(),
          ),
        
        name: routeData.route);
        break;
      case Routes.helpTickets:
        route = _createRouteDefault(
          screen: RepositoryProvider(
            create: (_) => const HelpRepository(),
            child: const HelpTicketsScreen(),
          ),

        name: routeData.route);
        break;
      case Routes.reportIssue:
        IssueArgs issueArgs = routeData.args as IssueArgs;
        route = _createFullScreenDialogRoute(
          screen: RepositoryProvider(
            create: (_) => const TransactionIssueRepository(),
            child: IssueScreen(type: issueArgs.type, transaction: issueArgs.transactionResource)
          ),

        name: routeData.route);
        break;
      default:
        route = SlideUpRoute(
          screen: const HomeScreen(),
        
        name: routeData.route);
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