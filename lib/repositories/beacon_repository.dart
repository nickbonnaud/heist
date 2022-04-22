import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/providers/beacon_provider.dart';

@immutable
class BeaconRepository {
  final BeaconProvider _beaconProvider = const BeaconProvider();

  const BeaconRepository();

  Stream<MonitoringResult> startMonitoring({required List<Business> businesses}) {
    return _beaconProvider.startMonitoring(businesses: businesses);
  }
}