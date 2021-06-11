import 'package:flutter/material.dart';
import 'package:heist/dev_keys.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

typedef NotificationReceivedCallback = Function(OSNotificationReceivedEvent event);
typedef NotificationOpenedCallback = Function(OSNotificationOpenedResult result);

@immutable
class PushNotificationProvider {

  void startMonitoring({required NotificationReceivedCallback onMessageReceived, required NotificationOpenedCallback onMessageInteraction}) {
    // Remove after debug
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(DevKeys.oneSignal);

    OneSignal.shared.setLocationShared(false);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(onMessageReceived);
    OneSignal.shared.setNotificationOpenedHandler(onMessageInteraction);
  }
}