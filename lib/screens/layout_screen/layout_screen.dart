import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/screens/home_screen/home_screen.dart';

import 'bloc/side_menu_bloc.dart';
import 'widgets/side_drawer.dart';

// TODO: Fix this using app router

class LayoutScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

// class LayoutScreen extends StatelessWidget {
//   final GeoLocationBloc _geoLocationBloc;
//   final NearbyBusinessesBloc _nearbyBusinessesBloc;
//   final HelpRepository _helpRepository;
//   final TransactionRepository _transactionRepository;
//   final BusinessRepository _businessRepository;

//   LayoutScreen({
//     required GeoLocationBloc geoLocationBloc,
//     required NearbyBusinessesBloc nearbyBusinessesBloc,
//     required HelpRepository helpRepository,
//     required TransactionRepository transactionRepository,
//     required BusinessRepository businessRepository
//   })
//     : _geoLocationBloc = geoLocationBloc,
//       _nearbyBusinessesBloc = nearbyBusinessesBloc,
//       _helpRepository = helpRepository,
//       _transactionRepository = transactionRepository,
//       _businessRepository = businessRepository;
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: BlocProvider<SideMenuBloc>(
//         create: (_) => SideMenuBloc(),
//         child: SideDrawer(
//           homeScreen: HomeScreen(
//             geoLocationBloc: _geoLocationBloc,
//             nearbyBusinessesBloc: _nearbyBusinessesBloc,
//           ),
//           helpRepository: _helpRepository,
//           transactionRepository: _transactionRepository,
//           businessRepository: _businessRepository,
//         ),
//       )
//     );
//   }
// }