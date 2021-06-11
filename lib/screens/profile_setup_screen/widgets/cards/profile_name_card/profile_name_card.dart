import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/profile_repository.dart';

import 'widgets/bloc/profile_name_form_bloc.dart';
import 'widgets/profile_name_body.dart';


class ProfileNameCard extends StatelessWidget {
  final ProfileRepository _profileRepository;
  final CustomerBloc _customerBloc;

  ProfileNameCard({required ProfileRepository profileRepository, required CustomerBloc customerBloc})
    : _profileRepository = profileRepository,
      _customerBloc = customerBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileNameFormBloc>(
      create: (BuildContext context) => ProfileNameFormBloc(profileRepository: _profileRepository, customerBloc: _customerBloc),
      child: ProfileNameBody(),
    );
  }
}