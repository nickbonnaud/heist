part of 'push_notification_bloc.dart';

abstract class PushNotificationEvent extends Equatable {
  const PushNotificationEvent();
}

class StartPushNotificationMonitoring extends PushNotificationEvent {
  final Function onMessageReceived;
  final Function onMessageInteraction;

  const StartPushNotificationMonitoring({@required this.onMessageReceived, @required this.onMessageInteraction});
  
  @override
  List<Object> get props => [onMessageReceived, onMessageInteraction];

  @override
  String toString() => 'StartPushNotificationMonitoring { onMessageReceived: $onMessageReceived, onMessageInteractionL: $onMessageInteraction }';
}