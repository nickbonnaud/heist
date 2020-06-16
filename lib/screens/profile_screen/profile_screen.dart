import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:heist/screens/profile_screen/widgets/profile_form.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: BottomModalAppBar(),
      body: BlocProvider<ProfileFormBloc>(
        create: (BuildContext context) => ProfileFormBloc(profileRepository: _profileRepository, authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: ProfileForm(customer: BlocProvider.of<AuthenticationBloc>(context).customer, profileRepository: _profileRepository),
      )
    );
  }  
}