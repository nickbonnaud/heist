import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';

import 'cards/profile_name_card/profile_name_card.dart';
import 'cards/profile_photo_card.dart';
import 'cards/setup_payment_account_card.dart';
import 'cards/setup_tip_screen.dart/setup_tip_card.dart';

class ProfileSetupCards extends StatelessWidget {
  final CustomerBloc _customerBloc;
  final ProfileRepository _profileRepository;
  final PhotoRepository _photoRepository;
  final PhotoPickerRepository _photoPickerRepository;
  final AccountRepository _accountRepository;

  ProfileSetupCards({
    required CustomerBloc customerBloc,
    required ProfileRepository profileRepository,
    required PhotoRepository photoRepository,
    required PhotoPickerRepository photoPickerRepository,
    required AccountRepository accountRepository
  })
    : _customerBloc = customerBloc,
      _profileRepository = profileRepository,
      _photoRepository = photoRepository,
      _photoPickerRepository = photoPickerRepository,
      _accountRepository = accountRepository;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSetupScreenBloc, ProfileSetupScreenState>(
      listener: (context, state) {
        if (state.isComplete) Navigator.of(context).pop();
      },
      child: BlocBuilder<ProfileSetupScreenBloc, ProfileSetupScreenState>(
        builder: (context, state) => Stack(
          children: [
            ..._createCards(context: context)
          ],
        )
      )
    );
  }

  List<Widget> _createCards({required BuildContext context}) {
    List<Widget> cards = [];
    Section.values.forEach((section) { 
      cards.add(_createCard(context: context, section: section));
    });
    return cards;
  }

  Widget _createCard({required BuildContext context, required Section section}) {
    List<Section> currentIncompleteSections = BlocProvider.of<ProfileSetupScreenBloc>(context).incompleteSections;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      top: currentIncompleteSections.contains(section) 
        ? currentIncompleteSections.indexOf(section) * 15.0
        : MediaQuery.of(context).size.height,
      bottom: currentIncompleteSections.contains(section)
        ? 0.0
        : - MediaQuery.of(context).size.height,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), 
              spreadRadius: 5.0,
              blurRadius: 5,
              offset: Offset(0, -5)
            )
          ]
        ),
        child: _setBody(section: section),
      ), 
    );
  }

  Widget _setBody({required Section section}) {
    Widget screen;
    switch (section) {
      case Section.name:
        screen = ProfileNameCard(
          customerBloc: _customerBloc,
          profileRepository: _profileRepository,
        );
        break;
      case Section.photo:
        screen = ProfilePhotoCard(
          profile: _customerBloc.state.customer!.profile,
          photoRepository: _photoRepository,
          photoPickerRepository: _photoPickerRepository,
          customerBloc: _customerBloc,
        );
        break;
      case Section.paymentAccount:
        screen = SetupPaymentAccountCard(
          customerBloc: _customerBloc,
        );
        break;
      case Section.tip:
        screen = SetupTipCard(
          customerBloc: _customerBloc,
          accountRepository: _accountRepository,
        );
        break;
      default: screen = Container();
    }
    return screen;
  }
}