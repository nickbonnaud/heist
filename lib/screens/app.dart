import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/push_notification/push_notification_bloc.dart';
import 'package:heist/resources/helpers/push_notification_handlers/action_button_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/app_opened_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/message_received_handler.dart';
import 'package:heist/screens/layout_screen/layout_screen.dart';
import 'package:heist/screens/onboard_screen/onboard_screen.dart';
import 'package:heist/screens/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PermissionsBloc, PermissionsState>(
          listener: (context, state) {
            if (state.checksComplete && !BlocProvider.of<BootBloc>(context).arePermissionChecksComplete) {
              BlocProvider.of<BootBloc>(context).add(PermissionChecksComplete());
            }
            
            if (state.onStartPermissionsValid && !BlocProvider.of<GeoLocationBloc>(context).isGeoLocationReady) {
              BlocProvider.of<GeoLocationBloc>(context).add(GeoLocationReady());
            }

            if (state.notificationEnabled && !BlocProvider.of<NotificationBootBloc>(context).isPermissionReady) {
              BlocProvider.of<NotificationBootBloc>(context).add(PermissionReady());
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
              BlocProvider.of<NotificationBootBloc>(context).add(NearbyBusinessesReady());
              // TEST: Building active locations
              // state.businesses.take(2).forEach((business) {
              //   BlocProvider.of<ActiveLocationBloc>(context).add(NewActiveLocation(beaconIdentifier: business.location.beacon.identifier));
              // });
            }
          },
        ),
        BlocListener<OpenTransactionsBloc, OpenTransactionsState>(
          listener: (context, state) {
            if (state is OpenTransactionsLoaded) {
              BlocProvider.of<NotificationBootBloc>(context).add(OpenTransactionsReady());
            }
          },
        ),
        BlocListener<NotificationBootBloc, NotificationBootState>(
          listener: (context, state) {
            if (state.isReady) {
              BlocProvider.of<PushNotificationBloc>(context).add(StartPushNotificationMonitoring(
                onMessageReceived: ((OSNotification notification) {
                  MessageReceivedHandler handler = MessageReceivedHandler();
                  handler.init(context: context, oSNotification: notification);
                }),
                onMessageInteraction: ((OSNotificationOpenedResult interaction) {
                  if (interaction.action?.actionId != null) {
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
        )
      ],
      child: BlocBuilder<BootBloc, BootState>(
        builder: (context, state) {
          if (state.checksComplete) {
            bool permissionsReady = BlocProvider.of<PermissionsBloc>(context).allPermissionsValid;
            if (!state.customerOnboarded || !permissionsReady) {
              return OnboardScreen(customerOnboarded: state.customerOnboarded, permissionsReady: permissionsReady);
            } else if (state.isDataLoaded) {
              return LayoutScreen();
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