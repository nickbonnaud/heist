import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/screens/settings_screen/widgets/settings_list.dart';

class SettingsScreen extends StatelessWidget {
  final CustomerBloc _customerBloc;
  final CustomerRepository _customerRepository;
  final ProfileRepository _profileRepository;
  final PhotoRepository _photoRepository;
  final PhotoPickerRepository _photoPickerRepository;
  final AccountRepository _accountRepository;
  final AuthenticationRepository _authenticationRepository;

  SettingsScreen({
    required CustomerBloc customerBloc,
    required CustomerRepository customerRepository,
    required ProfileRepository profileRepository,
    required PhotoRepository photoRepository,
    required PhotoPickerRepository photoPickerRepository,
    required AccountRepository accountRepository,
    required AuthenticationRepository authenticationRepository
  })
    : _customerBloc = customerBloc,
      _customerRepository = customerRepository,
      _profileRepository = profileRepository,
      _photoRepository = photoRepository,
      _photoPickerRepository = photoPickerRepository,
      _accountRepository = accountRepository,
      _authenticationRepository = authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (BuildContext context) => DefaultAppBarBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DefaultAppBar(title: 'Settings'),
        body: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SettingsList(
            customerBloc: _customerBloc,
            customer: _customerBloc.state.customer!,
            customerRepository: _customerRepository,
            profileRepository: _profileRepository,
            photoRepository: _photoRepository,
            photoPickerRepository: _photoPickerRepository,
            accountRepository: _accountRepository,
            authenticationRepository: _authenticationRepository,
          )
        ),
      ),
    );
  }
}