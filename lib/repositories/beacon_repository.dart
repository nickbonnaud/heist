import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/providers/beacon_provider.dart';

class BeaconRepository {
  final BeaconProvider _beaconProvider = BeaconProvider();

  Stream<MonitoringResult> startMonitoring(List<Business> businesses) {
    return _beaconProvider.startMonitoring(businesses);
  }
}