import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';

import 'bloc/onboard_bloc.dart';
import 'widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {
  final PermissionsBloc _permissionsBloc;
  final GeoLocationBloc _geoLocationBloc;
  final InitialLoginRepository _initialLoginRepository;
  final CustomerBloc _customerBloc;
  final ProfileRepository _profileRepository;
  final PhotoRepository _photoRepository;
  final AccountRepository _accountRepository;
  final PhotoPickerRepository _photoPickerRepository;

  OnboardScreen({
    required PermissionsBloc permissionsBloc,
    required GeoLocationBloc geoLocationBloc,
    required InitialLoginRepository initialLoginRepository,
    required CustomerBloc customerBloc,
    required ProfileRepository profileRepository,
    required PhotoRepository photoRepository,
    required AccountRepository accountRepository,
    required PhotoPickerRepository photoPickerRepository
  })
    : _permissionsBloc = permissionsBloc,
      _geoLocationBloc = geoLocationBloc,
      _initialLoginRepository = initialLoginRepository,
      _customerBloc = customerBloc,
      _profileRepository = profileRepository,
      _photoRepository = photoRepository,
      _accountRepository = accountRepository,
      _photoPickerRepository = photoPickerRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<OnboardBloc>(
        create: (BuildContext context) => OnboardBloc(
          customerStatus: _customerBloc.customer!.status,
          numberValidPermissions: _permissionsBloc.numberValidPermissions
        ),
        child: OnboardBody(
          permissionsBloc: _permissionsBloc,
          geoLocationBloc: _geoLocationBloc,
          initialLoginRepository: _initialLoginRepository,
          customerBloc: _customerBloc,
          profileRepository: _profileRepository,
          photoRepository: _photoRepository,
          accountRepository: _accountRepository,
          photoPickerRepository: _photoPickerRepository,
          customerStatus: _customerBloc.customer!.status,
        ),
      ),
    );
  }
}