import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:heist/models/business/business.dart';

@immutable
class BeaconProvider {

  const BeaconProvider();
  
  Stream<MonitoringResult> startMonitoring({required List<Business> businesses}) {
    List<Region> regions = _getRegions(businesses: businesses);
    return flutterBeacon.monitoring(regions);
  }

  List<Region> _getRegions({required List<Business> businesses}) {
    return businesses.map((business) {
      return Region(
        identifier: business.location.beacon.regionIdentifier,
        proximityUUID: business.location.beacon.proximityUUID,
        major: business.location.beacon.major,
        minor: business.location.beacon.minor
      );
    }).toList();
  }
}