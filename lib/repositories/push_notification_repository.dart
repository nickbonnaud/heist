import 'package:heist/providers/push_notification_provider.dart';
import 'package:meta/meta.dart';

class PushNotificationRepository {
  final PushNotificationProvider _pushNotificationProvider = PushNotificationProvider();

  void startMonitoring({@required Function onMessageReceived, @required Function onMessageInteraction}) {
    _pushNotificationProvider.startMonitoring(onMessageReceived: onMessageReceived, onMessageInteraction: onMessageInteraction);
  }
}