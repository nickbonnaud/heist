import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/providers/icon_creator_provider.dart';
import 'package:heist/screens/home_screen/widgets/home_screen_body/widgets/nearby_businesses_map/models/pre_marker.dart';

@immutable
class IconCreatorRepository {
  static const Size _size = Size(150, 150);
  final IconCreatorProvider _iconCreatorProvider;

  const IconCreatorRepository({required IconCreatorProvider iconCreatorProvider})
    : _iconCreatorProvider = iconCreatorProvider;

  Future<List<PreMarker>> createPreMarkers({required List<Business> businesses}) async {
    return await Future.wait(businesses.map((business) async {
      BitmapDescriptor marker = await _iconCreatorProvider.createMarkers(size: _size, business: business);
      return PreMarker(
        markerId: business.identifier,
        lat: business.location.geo.lat,
        lng: business.location.geo.lng,
        icon: marker,
        business: business
      );
    }));
  }
}