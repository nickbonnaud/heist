import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/providers/icon_creator_provider.dart';
import 'package:heist/screens/home_screen/widgets/home_screen_body/widgets/nearby_businesses_map/models/pre_marker.dart';

@immutable
class IconCreatorRepository {
  final IconCreatorProvider? _iconCreatorProvider;

  const IconCreatorRepository({IconCreatorProvider? iconCreatorProvider})
    : _iconCreatorProvider = iconCreatorProvider;

  Future<List<PreMarker>> createPreMarkers({required List<Business> businesses, Size? size}) async {
    IconCreatorProvider iconCreatorProvider = _iconCreatorProvider ?? const IconCreatorProvider();
    
    return await Future.wait(businesses.map((business) async {
      BitmapDescriptor marker = await iconCreatorProvider.createMarkers(
        size: size ?? Size(150.r, 150.r),
        business: business
      );
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