import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/screens/business_screen/business_screen.dart';
import 'package:heist/screens/home_screen/blocs/business_screen_visible_cubit.dart';
import 'package:heist/screens/home_screen/blocs/side_drawer_bloc/side_drawer_bloc.dart';

import '../../models/pre_marker.dart';
import 'bloc/google_map_screen_bloc.dart';

class GoogleMapScreen extends StatefulWidget{
  final double _latitude;
  final double _longitude;
  final List<PreMarker> _preMarkers;

  GoogleMapScreen({
    required double latitude,
    required double longitude,
    required List<PreMarker> preMarkers,
  })
    : _latitude = latitude,
      _longitude = longitude,
      _preMarkers = preMarkers;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}
  
class _GoogleMapScreenState extends State<GoogleMapScreen> {
  static const MAP_KEY = 'MAP_KEY';
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoogleMapScreenBloc, GoogleMapScreenState>(
      listener: (context, state) {
        if (state.business != null) {
          _showBusinessSheet(business:  state.business!);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
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
              markers: _createMarkers(preMarkers: widget._preMarkers),
              myLocationButtonEnabled: false,
            ),
            BlocBuilder<GoogleMapScreenBloc, GoogleMapScreenState>(
              builder: (context, state) {
                if (state.screenCoordinate != null) {
                  return Positioned(
                    key: Key("${state.business!.identifier}"),
                    top: state.screenCoordinate!.y.toDouble().h - 40.h,
                    left: state.screenCoordinate!.x.toDouble().w - 5.h,
                    child: CachedAvatarHero(
                      url: state.business!.photos.logo.smallUrl, 
                      radius: 5.w, 
                      tag: state.business!.identifier + "-map"
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
          onPressed: () => _changeLocation(),
        ),
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Marker _createCustomerLocationMarker() {
    return Marker(
      markerId: MarkerId('customer_marker'),
      position: LatLng(widget._latitude, widget._longitude)
    );
  }

  void _changeLocation() {
    BlocProvider.of<GeoLocationBloc>(context).add(FetchLocation(accuracy: Accuracy.MEDIUM));
  }

  void _showBusinessSheet({required Business business}) {
    context.read<BusinessScreenVisibleCubit>().toggle();
    BlocProvider.of<SideDrawerBloc>(context).add(ButtonVisibilityChanged(isVisible: false));
    
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      fullscreenDialog: true,
      pageBuilder: (BuildContext context, _, __) => BusinessScreen(business: business, fromMapScreen: true)
    )).then((_) {
      context.read<BusinessScreenVisibleCubit>().toggle();
        BlocProvider.of<SideDrawerBloc>(context).add(ButtonVisibilityChanged(isVisible: true));
      
      Future.delayed(Duration(milliseconds: 300)).then((_) =>
        BlocProvider.of<GoogleMapScreenBloc>(context).add(Reset()) 
      );
    });
  }

  Set<Marker> _createMarkers({required List<PreMarker> preMarkers}) {
    Set<Marker> markers = preMarkers.map((PreMarker preMarker) {
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
    return markers;
  }
}