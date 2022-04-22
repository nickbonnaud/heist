import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/profile_repository.dart';

import 'widgets/bloc/profile_name_form_bloc.dart';
import 'widgets/profile_name_body.dart';


class ProfileNameCard extends StatelessWidget {

  const ProfileNameCard({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileNameFormBloc>(
      create: (BuildContext context) => ProfileNameFormBloc(
        profileRepository: RepositoryProvider.of<ProfileRepository>(context),
        customerBloc: BlocProvider.of<CustomerBloc>(context)
      ),
      child: const ProfileNameBody(),
    );
  }
}