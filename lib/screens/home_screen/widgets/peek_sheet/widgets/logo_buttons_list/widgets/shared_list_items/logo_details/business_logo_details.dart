import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/resources/helpers/distance_calculator.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/business_screen/business_screen.dart';
import 'package:heist/themes/global_colors.dart';

class BusinessLogoDetails extends StatelessWidget {
  final double _topMargin;
  final double _leftMargin;
  final double _height;
  final double _borderRadius;
  final Business _business;
  final AnimationController _controller;

  BusinessLogoDetails({
    @required double topMargin,
    @required double leftMargin,
    @required double height,
    @required double borderRadius,
    @required Business business,
    @required AnimationController controller
  })
    : assert(
      topMargin != null &&
      leftMargin != null &&
      height != null &&
      borderRadius != null &&
      business != null &&
      controller != null
    ),
      _topMargin = topMargin,
      _leftMargin = leftMargin,
      _height = height,
      _borderRadius = borderRadius,
      _business = business,
      _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topMargin,
      left: _leftMargin,
      height: _height,
      right: 16,
      child: AnimatedOpacity(
        opacity: _controller.status == AnimationStatus.completed ? 1 : 0, 
        duration: Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: () => _viewBusinessModal(context: context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              color: Theme.of(context).colorScheme.scrollBackgroundLight
            ),
            padding: EdgeInsets.only(left: _height).add(EdgeInsets.all(8)),
            child: _buildContent(context: context),
          ),
        ),
      )
    );
  }

  Widget _buildContent({@required BuildContext context}) {
    return _controller.status == AnimationStatus.completed ? Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PlatformText(
          "${_business.profile.name}",
          style: TextStyle(
            fontSize: SizeConfig.getWidth(4) * _controller.value,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.textOnLight
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.pin_drop),
            BlocBuilder<GeoLocationBloc, GeoLocationState>(
              builder: (context, state) {
                if (state is LocationLoaded) {
                  return PlatformText(
                    "${_getDistance(state: state)} miles away.",
                    style: TextStyle(
                      fontSize: SizeConfig.getWidth(4) * _controller.value,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.textOnLightSubdued,
                    ),
                  );
                }
                return Container();
              }
            )
          ],
        )
      ],
    ) : Container();
  }
  
  void _viewBusinessModal({@required BuildContext context}) {
    showPlatformModalSheet(
      context: context, 
      builder: (_) => BusinessScreen(business: _business)
    );
  }

  String _getDistance({@required LocationLoaded state}) {
    return DistanceCalculator.getDistance(
      lat1: state.latitude,
      lng1: state.longitude, 
      lat2: _business.location.geo.lat, 
      lng2: _business.location.geo.lng
    );
  }
}