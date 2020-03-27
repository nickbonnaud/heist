import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:heist/models/business/business.dart';

class BeaconProvider {

  Stream<MonitoringResult> startMonitoring(List<Business> businesses) {
    List<Region> regions = _getRegions(businesses);
    return flutterBeacon.monitoring(regions);
  }

  List<Region> _getRegions(List<Business> businesses) {
    return businesses.map((business) {
      return Region(
        identifier: business.location.beacon.regionIdentifier,
        proximityUUID: business.location.beacon.identifier,
        major: business.location.beacon.major,
        minor: business.location.beacon.minor
      );
    }).toList();
  }
}