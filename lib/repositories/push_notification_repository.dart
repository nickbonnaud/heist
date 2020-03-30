import 'package:heist/providers/push_notification_provider.dart';

class PushNotificationRepository {
  final PushNotificationProvider _pushNotificationProvider = PushNotificationProvider();

  void startMonitoring(Function onMessage, Function onLaunch, Function onResume) {
    _pushNotificationProvider.startMonitoring(onMessage, onLaunch, onResume);
  }
}