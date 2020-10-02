import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/profile_repository.dart';

import 'widgets/bloc/profile_name_form_bloc.dart';
import 'widgets/profile_name_body.dart';


class ProfileNameCard extends StatelessWidget {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileNameFormBloc>(
      create: (BuildContext context) => ProfileNameFormBloc(profileRepository: _profileRepository, authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
      child: ProfileNameBody(),
    );
  }
}