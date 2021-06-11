import 'package:heist/providers/push_notification_provider.dart';
import 'package:meta/meta.dart';

@immutable
class PushNotificationRepository {
  final PushNotificationProvider _pushNotificationProvider;

  const PushNotificationRepository({required PushNotificationProvider pushNotificationProvider})
    : _pushNotificationProvider = pushNotificationProvider;

  void startMonitoring({required NotificationReceivedCallback onMessageReceived, required NotificationOpenedCallback onMessageInteraction}) {
    _pushNotificationProvider.startMonitoring(onMessageReceived: onMessageReceived, onMessageInteraction: onMessageInteraction);
  }
}