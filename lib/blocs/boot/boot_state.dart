part of 'boot_bloc.dart';

@immutable
class BootState {
  final bool customerOnboarded;
  final bool checksComplete;

  final bool openTransactionsLoaded;
  final bool nearbyBusinessesLoaded;
  final bool beaconsLoaded;

  bool get isDataLoaded => openTransactionsLoaded && nearbyBusinessesLoaded && beaconsLoaded;

  BootState({
    @required this.customerOnboarded,
    @required this.checksComplete,
    @required this.openTransactionsLoaded,
    @required this.nearbyBusinessesLoaded,
    @required this.beaconsLoaded,
  });

  factory BootState.initial() {
    return BootState(
      customerOnboarded: true,
      checksComplete: false,
      openTransactionsLoaded: false,
      nearbyBusinessesLoaded: false,
      beaconsLoaded: false,
    );
  }

  BootState update({
    bool customerOnboarded,
    bool checksComplete,
    bool openTransactionsLoaded,
    bool nearbyBusinessesLoaded,
    bool beaconsLoaded,
  }) {
    return _copyWith(
      customerOnboarded: customerOnboarded,
      checksComplete: checksComplete,
      openTransactionsLoaded: openTransactionsLoaded,
      nearbyBusinessesLoaded: nearbyBusinessesLoaded,
      beaconsLoaded: beaconsLoaded,
    );
  }

  BootState _copyWith({
    bool customerOnboarded,
    bool checksComplete,
    bool openTransactionsLoaded,
    bool nearbyBusinessesLoaded,
    bool beaconsLoaded,
  }) {
    return BootState(
      customerOnboarded: customerOnboarded ?? this.customerOnboarded,
      checksComplete: checksComplete ?? this.checksComplete,
      openTransactionsLoaded: openTransactionsLoaded ?? this.openTransactionsLoaded,
      nearbyBusinessesLoaded: nearbyBusinessesLoaded ?? this.nearbyBusinessesLoaded,
      beaconsLoaded: beaconsLoaded ?? this.beaconsLoaded,
    );
  }

  @override
  String toString() => 'BootState { customerOnboarded: $customerOnboarded, checksComplete: $checksComplete, openTransactionsLoaded: $openTransactionsLoaded, nearbyBusinessesLoaded: $nearbyBusinessesLoaded, beaconsLoaded: $beaconsLoaded }';
}