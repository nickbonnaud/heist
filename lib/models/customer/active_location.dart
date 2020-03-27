import 'package:equatable/equatable.dart';

class ActiveLocation extends Equatable {
  final String identifier;
  final String beaconIdentifier;
  final String transactionIdentifier;
  final String lastNotification;
  final String error;

  ActiveLocation({this.identifier, this.beaconIdentifier, this.transactionIdentifier, this.lastNotification, this.error});

  ActiveLocation.fromJson(Map<String, dynamic> json)
    : identifier = json['active_location_id'],
      beaconIdentifier = json['beacon_identifier'],
      transactionIdentifier = json['transaction_id'],
      lastNotification = json['last_notification'],
      error = "";

  ActiveLocation.withError(String error)
    : identifier = null,
    beaconIdentifier = null,
      transactionIdentifier = null,
      lastNotification = null,
      error = error;

  @override
  List<Object> get props => [identifier, beaconIdentifier, transactionIdentifier, lastNotification, error];

  @override
  String toString() => 'ActiveLocation { identifier: $identifier, beaconIdentifier: $beaconIdentifier, transactionIdentifier: $transactionIdentifier, lastNotification: $lastNotification, error: $error }';
}