import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationProvider {

  void startMonitoring({@required Function onMessageReceived, @required Function onMessageInteraction}) {
    // Remove after debug
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(
      "e82fd6e7-3b1f-41d5-9774-a4467bccb7a7",
      iOSSettings: {
        OSiOSSettings.autoPrompt: false,
        OSiOSSettings.inAppLaunchUrl: true
      }
    );

    OneSignal.shared.setLocationShared(false);
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationReceivedHandler(onMessageReceived);
    OneSignal.shared.setNotificationOpenedHandler(onMessageInteraction);
  }
}