import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/push_notification/push_notification_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/push_notification_handlers/action_button_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/app_opened_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/foreground_handler.dart';
import 'package:heist/resources/http/mock_responses.dart';
import 'package:heist/screens/home_screen/home_screen.dart';
import 'package:heist/screens/onboard_screen/onboard_screen.dart';
import 'package:heist/screens/permission_screen/permission_screen.dart';
import 'package:heist/screens/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PermissionsBloc, PermissionsState>(
          listener: (context, state) {
            if (state.checksComplete) {
              BlocProvider.of<BootBloc>(context).add(PermissionChecksComplete());
            }
            
            if (state.onStartPermissionsValid) {
              BlocProvider.of<GeoLocationBloc>(context).add(GeoLocationReady());
            }

            if (state.notificationEnabled) {
              BlocProvider.of<PushNotificationBloc>(context).add(StartPushNotificationMonitoring(
                onMessageReceived: ((OSNotification notification) {
                  ForegroundHandler handler = ForegroundHandler();
                  handler.init(context: context, oSNotification: notification);
                }),
                onMessageInteraction: ((OSNotificationOpenedResult interaction) {
                  if (interaction.action.actionId != null) {
                    ActionButtonHandler handler = ActionButtonHandler();
                    handler.init(context: context, interaction: interaction);
                  } else {
                    AppOpenedHandler handler = AppOpenedHandler();
                    handler.init(context: context, interaction: interaction);
                  }
                })
              ));
            }
          },
        ),
        BlocListener<GeoLocationBloc, GeoLocationState>(
          listener: (context , state) {
            if (state is LocationLoaded) {
              BlocProvider.of<NearbyBusinessesBloc>(context).add(FetchNearby(lat: state.latitude, lng: state.longitude));
            }
          }
        ),
        BlocListener<NearbyBusinessesBloc, NearbyBusinessesState>(
          listener: (context , state) {
            if (state is NearbyBusinessLoaded) {
              BlocProvider.of<BeaconBloc>(context).add(StartBeaconMonitoring(businesses: state.businesses));

              // TEST: Building active locations
              // state.businesses.forEach((business) {
              //   BlocProvider.of<ActiveLocationBloc>(context).add(NewActiveLocation(beaconIdentifier: business.location.beacon.identifier));
              // });
            }

            // remove this as well
            TransactionResource transaction = TransactionResource.fromJson(MockResponses.mockOpenTransaction());
            BlocProvider.of<OpenTransactionsBloc>(context).add(AddOpenTransaction(transaction: transaction));
          },
        ),
      ],
      child: BlocBuilder<BootBloc, BootState>(
        builder: (context, state) {
          if (state.checksComplete) {
            bool permissionsReady = BlocProvider.of<PermissionsBloc>(context).allPermissionsValid;
            if (!state.customerOnboarded || !permissionsReady) {
              return OnboardScreen(customerOnboarded: state.customerOnboarded, permissionsReady: permissionsReady);
            } else if (state.isDataLoaded) {
              return HomeScreen();
            } else {
              return SplashScreen(shouldAnimate: true);
            }
          } else {
            return SplashScreen(shouldAnimate: true);
          }
        }
      )
    );
  }
}