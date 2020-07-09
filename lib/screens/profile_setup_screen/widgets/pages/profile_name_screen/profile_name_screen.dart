import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/screens/profile_setup_screen/widgets/pages/profile_name_screen/widgets/profile_name_body.dart';

import 'widgets/bloc/profile_name_form_bloc.dart';


class ProfileNameScreen extends StatelessWidget {
  final AnimationController _controller;
  final ProfileRepository _profileRepository = ProfileRepository();

  ProfileNameScreen({@required AnimationController controller})
    : assert(controller != null),
      _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BlocProvider<ProfileNameFormBloc>(
        create: (BuildContext context) => ProfileNameFormBloc(profileRepository: _profileRepository, authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: ProfileNameBody(controller: _controller),
      ),
    );
  }
}