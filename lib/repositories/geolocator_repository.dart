import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heist/providers/geolocator_provider.dart';

@immutable
class GeolocatorRepository {
  final GeolocatorProvider? _geolocatorProvider;

  const GeolocatorRepository({GeolocatorProvider? geolocatorProvider})
    : _geolocatorProvider = geolocatorProvider;

  Future<Position> fetchLow() async {
    GeolocatorProvider geolocatorProvider = _getGeolocatorProvider();
    return await geolocatorProvider.fetch(accuracy: LocationAccuracy.low);
  }

  Future<Position> fetchMed() async {
    GeolocatorProvider geolocatorProvider = _getGeolocatorProvider();
    return await geolocatorProvider.fetch(accuracy: LocationAccuracy.medium);
  }

  Future<Position> fetchHigh() async {
    GeolocatorProvider geolocatorProvider = _getGeolocatorProvider();
    return await geolocatorProvider.fetch(accuracy: LocationAccuracy.high);
  }

  Future<Position> fetchBest() async {
    GeolocatorProvider geolocatorProvider = _getGeolocatorProvider();
    return await geolocatorProvider.fetch(accuracy: LocationAccuracy.best);
  }

  GeolocatorProvider _getGeolocatorProvider() {
    return _geolocatorProvider ?? const GeolocatorProvider();
  }
}