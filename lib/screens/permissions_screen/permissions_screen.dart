import 'package:flutter/material.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/initial_login_repository.dart';

import 'widgets/permission_cards/permission_cards.dart';
import 'widgets/permission_cards/widgets/success_card.dart';
import 'widgets/permissions_animation/permissions_animation.dart';


class PermissionsScreen extends StatelessWidget {
  final PermissionsBloc _permissionsBloc;
  final GeoLocationBloc _geoLocationBloc;
  final InitialLoginRepository _initialLoginRepository;
  final String _customerIdentifier;

  const PermissionsScreen({
    required PermissionsBloc permissionsBloc,
    required GeoLocationBloc geoLocationBloc,
    required InitialLoginRepository initialLoginRepository,
    required String customerIdentifier,
    Key? key
  })
    : _permissionsBloc = permissionsBloc,
      _geoLocationBloc = geoLocationBloc,
      _initialLoginRepository = initialLoginRepository,
      _customerIdentifier = customerIdentifier,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff6f4),
      body: _constructBody(context: context)
    );
  }

  Widget _constructBody({required BuildContext context}) {
    return Column(
      key: const Key("permissionsScreenKey"),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PermissionsAnimation(permissionsBloc: _permissionsBloc,),
        Expanded(
          child: Stack(
            children: [
              const SuccessCard(),
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