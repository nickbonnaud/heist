import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/business_screen/business_screen.dart';

import '../../helpers/pre_marker.dart';
import 'bloc/google_map_screen_bloc.dart';

class GoogleMapScreen extends StatefulWidget{
  final double _latitude;
  final double _longitude;
  final List<PreMarker> _preMarkers;

  GoogleMapScreen({@required double latitude, @required double longitude, @required List<PreMarker> preMarkers})
    : assert(latitude != null && longitude != null && preMarkers != null),
      _latitude = latitude,
      _longitude = longitude,
      _preMarkers = preMarkers;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}
  
class _GoogleMapScreenState extends State<GoogleMapScreen> {
  static const MAP_KEY = 'MAP_KEY';
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoogleMapScreenBloc, GoogleMapScreenState>(
      listener: (context, state) {
        if (state.screenCoordinate != null) {
          _showBusinessSheet(context: context, business:  state.business);
        }
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller) => _controller = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget._latitude, widget._longitude),
                zoom: 14.0,
              ),
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()
                )
              ].toSet(),
              markers: _createMarkers(widget._preMarkers, context),
              myLocationButtonEnabled: false,
            ),
            BlocBuilder<GoogleMapScreenBloc, GoogleMapScreenState>(
              builder: (context, state) {
                if (state.screenCoordinate != null) {
                  return Positioned(
                    top: state.screenCoordinate.y.toDouble() - SizeConfig.getHeight(6),
                    left: state.screenCoordinate.x.toDouble() - SizeConfig.getWidth(7),
                    child: CachedAvatarHero(
                      url: state.business.photos.logo.smallUrl, 
                      radius: 7, 
                      tag: state.business.identifier + "-map"
                    )
                  );
                }
                return Container();
              }
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: MAP_KEY,
          child: Icon(Icons.my_location),
          onPressed: () => _changeLocation(context),
        ),
      )
    );
  }

  Marker _createCustomerLocationMarker() {
    return Marker(
      markerId: MarkerId('customer_marker'),
      position: LatLng(widget._latitude, widget._longitude)
    );
  }

  void _changeLocation(BuildContext context) {
    BlocProvider.of<GeoLocationBloc>(context).add(FetchLocation(accuracy: Accuracy.MEDIUM));
  }

  void _showBusinessSheet({@required BuildContext context, @required Business business}) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      fullscreenDialog: true,
      pageBuilder: (BuildContext context, _, __) => BusinessScreen(business: business, fromMapScreen: true)
    )).then((_) {
      Future.delayed(Duration(milliseconds: 300)).then((_) =>
        BlocProvider.of<GoogleMapScreenBloc>(context).add(Reset()) 
      );
    });
  }

  Set<Marker> _createMarkers(List<PreMarker> preMarkers, BuildContext context) {
    return preMarkers.map((PreMarker preMarker) {
      LatLng position = LatLng(preMarker.lat, preMarker.lng);
      return Marker(
        markerId: MarkerId(preMarker.markerId),
        position: position,
        icon: preMarker.icon,
        consumeTapEvents: true,
        onTap: () {
          _controller.getScreenCoordinate(position).then((ScreenCoordinate screenCoords) {
            BlocProvider.of<GoogleMapScreenBloc>(context).add(Tapped(screenCoordinate: screenCoords, business: preMarker.business));
          });
        }
      );
    }).toSet()..add(_createCustomerLocationMarker());
  }
}