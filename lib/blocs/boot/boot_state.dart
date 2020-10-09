part of 'boot_bloc.dart';

@immutable
class BootState {
  final bool customerOnboarded;
  final bool permissionChecksComplete;
  final bool permissionsReady;
  final bool authCheckComplete;
  final bool isAuthenticated;

  final bool openTransactionsLoaded;
  final bool nearbyBusinessesLoaded;
  final bool beaconsLoaded;

  bool get isDataLoaded => openTransactionsLoaded && nearbyBusinessesLoaded && beaconsLoaded;
  bool get areBusinessesLoaded => nearbyBusinessesLoaded;
  bool get areBeaconsLoaded => beaconsLoaded;
  bool get areOpenTransactionsLoaded => openTransactionsLoaded;

  BootState({
    @required this.customerOnboarded,
    @required this.permissionChecksComplete,
    @required this.permissionsReady,
    @required this.authCheckComplete,
    @required this.isAuthenticated,
    @required this.openTransactionsLoaded,
    @required this.nearbyBusinessesLoaded,
    @required this.beaconsLoaded,
  });

  factory BootState.initial() {
    return BootState(
      customerOnboarded: true,
      permissionChecksComplete: false,
      permissionsReady: false,
      authCheckComplete: false,
      isAuthenticated: false,
      openTransactionsLoaded: false,
      nearbyBusinessesLoaded: false,
      beaconsLoaded: false,
    );
  }

  BootState update({
    bool customerOnboarded,
    bool permissionChecksComplete,
    bool permissionsReady,
    bool authCheckComplete,
    bool isAuthenticated,
    bool openTransactionsLoaded,
    bool nearbyBusinessesLoaded,
    bool beaconsLoaded,
  }) {
    return _copyWith(
      customerOnboarded: customerOnboarded,
      permissionChecksComplete: permissionChecksComplete,
      permissionsReady: permissionsReady,
      authCheckComplete: authCheckComplete,
      isAuthenticated: isAuthenticated,
      openTransactionsLoaded: openTransactionsLoaded,
      nearbyBusinessesLoaded: nearbyBusinessesLoaded,
      beaconsLoaded: beaconsLoaded,
    );
  }

  BootState _copyWith({
    bool customerOnboarded,
    bool permissionChecksComplete,
    bool permissionsReady,
    bool authCheckComplete,
    bool isAuthenticated,
    bool openTransactionsLoaded,
    bool nearbyBusinessesLoaded,
    bool beaconsLoaded,
  }) {
    return BootState(
      customerOnboarded: customerOnboarded ?? this.customerOnboarded,
      permissionChecksComplete: permissionChecksComplete ?? this.permissionChecksComplete,
      permissionsReady: permissionsReady ?? this.permissionsReady,
      authCheckComplete: authCheckComplete ?? this.authCheckComplete,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      openTransactionsLoaded: openTransactionsLoaded ?? this.openTransactionsLoaded,
      nearbyBusinessesLoaded: nearbyBusinessesLoaded ?? this.nearbyBusinessesLoaded,
      beaconsLoaded: beaconsLoaded ?? this.beaconsLoaded,
    );
  }

  @override
  String toString() => 'BootState { customerOnboarded: $customerOnboarded, permissionChecksComplete: $permissionChecksComplete, permissionsReady: $permissionsReady, authCheckComplete: $authCheckComplete, isAuthenticated: $isAuthenticated, openTransactionsLoaded: $openTransactionsLoaded, nearbyBusinessesLoaded: $nearbyBusinessesLoaded, beaconsLoaded: $beaconsLoaded }';
}