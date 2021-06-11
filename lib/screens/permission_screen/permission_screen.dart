import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/screens/permission_screen/widgets/permission_cards/widgets/success_card.dart';
import 'package:heist/screens/permission_screen/widgets/permissions_animation/permissions_animation.dart';

import 'widgets/permission_cards/permission_cards.dart';


class PermissionsScreen extends StatelessWidget {
  final PermissionsBloc _permissionsBloc;
  final GeoLocationBloc _geoLocationBloc;
  final InitialLoginRepository _initialLoginRepository;
  final String _customerIdentifier;

  PermissionsScreen({
    required PermissionsBloc permissionsBloc,
    required GeoLocationBloc geoLocationBloc,
    required InitialLoginRepository initialLoginRepository,
    required String customerIdentifier
  })
    : _permissionsBloc = permissionsBloc,
      _geoLocationBloc = geoLocationBloc,
      _initialLoginRepository = initialLoginRepository,
      _customerIdentifier = customerIdentifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff6f4),
      body: _constructBody(context: context)
    );
  }

  Widget _constructBody({required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PermissionsAnimation(permissionsBloc: _permissionsBloc,),
        Expanded(
          child: Stack(
            children: [
              SuccessCard(),
              PermissionCards(
                initialLoginRepository: _initialLoginRepository,
                geoLocationBloc: _geoLocationBloc,
                permissionsBloc: _permissionsBloc,
                customerIdentifier: _customerIdentifier,
              ),
            ],
          )
        )
      ],
    );
  }
}