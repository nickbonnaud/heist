part of 'notification_boot_bloc.dart';

@immutable
class NotificationBootState {
  final bool nearbyBusinessesReady;
  final bool openTransactionsReady;
  final bool permissionReady;

  bool get isReady => nearbyBusinessesReady && openTransactionsReady && permissionReady;

  NotificationBootState({
    @required this.nearbyBusinessesReady,
    @required this.openTransactionsReady,
    @required this.permissionReady
  });

  factory NotificationBootState.initial() {
    return NotificationBootState(
      nearbyBusinessesReady: false,
      openTransactionsReady: false,
      permissionReady: false
    );
  }

  NotificationBootState update({
    bool nearbyBusinessesReady,
    bool openTransactionsReady,
    bool permissionReady
  }) {
    return _copyWith(
      nearbyBusinessesReady: nearbyBusinessesReady,
      openTransactionsReady: openTransactionsReady,
      permissionReady: permissionReady
    );
  }
  
  NotificationBootState _copyWith({
    bool nearbyBusinessesReady,
    bool openTransactionsReady,
    bool permissionReady
  }) {
    return NotificationBootState(
      nearbyBusinessesReady: nearbyBusinessesReady ?? this.nearbyBusinessesReady,
      openTransactionsReady: openTransactionsReady ?? this.openTransactionsReady,
      permissionReady: permissionReady ?? this.permissionReady
    );
  }

  @override
  String toString() => 'NotificationBootState { nearbyBusinessesReady: $nearbyBusinessesReady, openTransactionsReady: $openTransactionsReady, permissionReady: $permissionReady }';
}
