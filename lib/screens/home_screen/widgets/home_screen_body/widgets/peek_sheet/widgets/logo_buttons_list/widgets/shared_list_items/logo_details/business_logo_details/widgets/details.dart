import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/resources/helpers/distance_calculator.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/home_screen/blocs/business_screen_visible_cubit.dart';
import 'package:heist/themes/global_colors.dart';

class Details extends StatefulWidget {
  final String _keyValue;
  final double _height;
  final double _borderRadius;
  final Business _business;
  final AnimationController _controller;
  final int _index;

  Details({
    required String keyValue,
    required double height,
    required double borderRadius,
    required Business business,
    required AnimationController controller,
    required int index
  })
    : _keyValue = keyValue,
      _height = height,
      _borderRadius = borderRadius,
      _business = business,
      _controller = controller,
      _index = index;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  late AnimationController _detailsController;
  bool _isPressed = false;
  static const _curve = Curves.easeIn;
  
  @override
  void initState() {
    super.initState();
    _detailsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    
    Future.delayed(Duration(milliseconds: 200 * widget._index), () => _detailsController.forward());
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _detailsController, curve: _curve),
      builder: (context, child) {
        return Opacity(
          opacity: _detailsController.value,
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: GestureDetector(
              key: Key(widget._keyValue),
              onTap: () => _viewBusinessModal(),
              onTapDown: (_) => setState(() => _isPressed = !_isPressed),
              onTapUp: (_) => setState(() => _isPressed = !_isPressed),
              onTapCancel: () => setState(() => _isPressed = !_isPressed),
              child: Material(
                elevation: _isPressed ? 0 : 5,
                borderRadius: BorderRadius.circular(widget._borderRadius),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget._borderRadius),
                    color: Theme.of(context).colorScheme.scrollBackground
                  ),
                  padding: EdgeInsets.only(left: widget._height).add(EdgeInsets.all(8)),
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PlatformText(
          "${widget._business.profile.name}",
          style: TextStyle(
            fontSize: SizeConfig.getWidth(4) * widget._controller.value,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary
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
                      fontSize: SizeConfig.getWidth(4) * widget._controller.value,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onPrimarySubdued,
                    ),
                  );
                }
                return Container();
              }
            )
          ],
        )
      ],
    );
  }

  void _viewBusinessModal() {
    context.read<BusinessScreenVisibleCubit>().toggle();
    Navigator.of(context).pushNamed(Routes.business, arguments: widget._business)
      .then((_) => context.read<BusinessScreenVisibleCubit>().toggle());
  }

  double _getDistance({required LocationLoaded state}) {
    return DistanceCalculator.getDistance(
      lat1: state.latitude,
      lng1: state.longitude, 
      lat2: widget._business.location.geo.lat, 
      lng2: widget._business.location.geo.lng
    );
  }
}