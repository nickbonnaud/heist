import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/screens/profile_setup_screen/widgets/profile_setup_cards.dart';

import 'bloc/profile_setup_screen_bloc.dart';

class ProfileSetupScreen extends StatelessWidget {
  final CustomerBloc _customerBloc;
  final ProfileRepository _profileRepository;
  final PhotoRepository _photoRepository;
  final AccountRepository _accountRepository;
  final PhotoPickerRepository _photoPickerRepository;

  ProfileSetupScreen({
    required CustomerBloc customerBloc,
    required ProfileRepository profileRepository,
    required PhotoRepository photoRepository,
    required AccountRepository accountRepository,
    required PhotoPickerRepository photoPickerRepository
  })
    : _customerBloc = customerBloc,
      _profileRepository = profileRepository,
      _photoRepository = photoRepository,
      _accountRepository = accountRepository,
      _photoPickerRepository = photoPickerRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("profileSetupScreenKey"),
      resizeToAvoidBottomInset: false,
      body: BlocProvider<ProfileSetupScreenBloc>(
        create: (context) => ProfileSetupScreenBloc()
          ..add(Init(status: _customerBloc.customer!.status)),
        child: SafeArea(
          bottom: false,
          child: ProfileSetupCards(
            customerBloc: _customerBloc,
            profileRepository: _profileRepository,
            photoRepository: _photoRepository,
            accountRepository: _accountRepository,
            photoPickerRepository: _photoPickerRepository,
          )
        )
      )
    );
  }
}