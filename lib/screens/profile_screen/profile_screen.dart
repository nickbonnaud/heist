import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:heist/screens/profile_screen/widgets/profile_form.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileRepository _profileRepository;
  final PhotoRepository _photoRepository;
  final Profile _profile;
  final PhotoPickerRepository _photoPickerRepository;
  final CustomerBloc _customerBloc;

  ProfileScreen({
    required ProfileRepository profileRepository,
    required PhotoRepository photoRepository,
    required Profile profile,
    required PhotoPickerRepository photoPickerRepository,
    required CustomerBloc customerBloc
  })
    : _profileRepository = profileRepository,
      _photoRepository = photoRepository,
      _profile = profile,
      _photoPickerRepository = photoPickerRepository,
      _customerBloc = customerBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: BottomModalAppBar(context: context),
      body: BlocProvider<ProfileFormBloc>(
        create: (BuildContext context) => ProfileFormBloc(
          profileRepository: _profileRepository, 
          customerBloc: _customerBloc
        ),
        child: ProfileForm(
          profile: _profile,
          photoRepository: _photoRepository,
          photoPickerRepository: _photoPickerRepository,
          customerBloc: _customerBloc
        ),
      )
    );
  }  
}