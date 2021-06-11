import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heist/providers/geolocator_provider.dart';

@immutable
class GeolocatorRepository {
  final GeolocatorProvider _geolocatorProvider;

  const GeolocatorRepository({required GeolocatorProvider geolocatorProvider})
    : _geolocatorProvider = geolocatorProvider;

  Future<Position> fetchLow() async {
    return await _geolocatorProvider.fetch(accuracy: LocationAccuracy.low);
  }

  Future<Position> fetchMed() async {
    return await _geolocatorProvider.fetch(accuracy: LocationAccuracy.medium);
  }

  Future<Position> fetchHigh() async {
    return await _geolocatorProvider.fetch(accuracy: LocationAccuracy.high);
  }

  Future<Position> fetchBest() async {
    return await _geolocatorProvider.fetch(accuracy: LocationAccuracy.best);
  }

  Future<LocationPermission> checkPermission() async {
    return await _geolocatorProvider.checkPermission();
  }

  Future<Position> fetchRecent() async {
    return await _geolocatorProvider.fetchRecent();
  }
}