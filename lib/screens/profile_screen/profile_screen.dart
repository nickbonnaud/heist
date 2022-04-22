import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:heist/screens/profile_screen/widgets/profile_form.dart';

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const BottomModalAppBar(),
      body: BlocProvider<ProfileFormBloc>(
        create: (BuildContext context) => ProfileFormBloc(
          profileRepository: RepositoryProvider.of<ProfileRepository>(context), 
          customerBloc: BlocProvider.of<CustomerBloc>(context)
        ),
        child: const ProfileForm(),
      )
    );
  }  
}