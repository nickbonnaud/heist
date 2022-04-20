part of 'notification_boot_bloc.dart';

@immutable
class NotificationBootState extends Equatable {
  final bool nearbyBusinessesReady;
  final bool openTransactionsReady;
  final bool permissionReady;

  bool get isReady => nearbyBusinessesReady && openTransactionsReady && permissionReady;

  const NotificationBootState({
    required this.nearbyBusinessesReady,
    required this.openTransactionsReady,
    required this.permissionReady
  });

  factory NotificationBootState.initial() {
    return const NotificationBootState(
      nearbyBusinessesReady: false,
      openTransactionsReady: false,
      permissionReady: false
    );
  }

  NotificationBootState update({
    bool? nearbyBusinessesReady,
    bool? openTransactionsReady,
    bool? permissionReady
  }) => NotificationBootState(
    nearbyBusinessesReady: nearbyBusinessesReady ?? this.nearbyBusinessesReady,
    openTransactionsReady: openTransactionsReady ?? this.openTransactionsReady,
    permissionReady: permissionReady ?? this.permissionReady
  );
  

  @override
  List<Object?> get props => [nearbyBusinessesReady, openTransactionsReady, permissionReady];
  
  @override
  String toString() => 'NotificationBootState { nearbyBusinessesReady: $nearbyBusinessesReady, openTransactionsReady: $openTransactionsReady, permissionReady: $permissionReady }';
}
