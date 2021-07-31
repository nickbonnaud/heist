import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/screens/home_screen/blocs/business_screen_visible_cubit.dart';

import 'blocs/side_drawer_bloc/side_drawer_bloc.dart';
import 'widgets/home_screen_body/home_screen_body.dart';
import 'widgets/side_drawer/side_drawer.dart';

class HomeScreen extends StatelessWidget {
  final GeoLocationBloc _geoLocationBloc;
  final NearbyBusinessesBloc _nearbyBusinessesBloc;

  HomeScreen({
    required GeoLocationBloc geoLocationBloc,
    required NearbyBusinessesBloc nearbyBusinessesBloc,
  })
    : _geoLocationBloc = geoLocationBloc,
      _nearbyBusinessesBloc = nearbyBusinessesBloc;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("homeScreenKey"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SideDrawerBloc>(
            create: (_) => SideDrawerBloc()
          ),
          
          BlocProvider<BusinessScreenVisibleCubit>(
            create: (_) => BusinessScreenVisibleCubit()
          ),
        ],
        child: SideDrawer(
          homeScreen: HomeScreenBody(
            nearbyBusinessesBloc: _nearbyBusinessesBloc,
            geoLocationBloc: _geoLocationBloc
          ),
        ),
      )
    );
  }
}