import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:heist/screens/profile_screen/widgets/profile_form.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: BlocProvider<ProfileFormBloc>(
            create: (BuildContext context) => ProfileFormBloc(profileRepository: _profileRepository, customerBloc: BlocProvider.of<CustomerBloc>(context)),
            child: ProfileForm(customer: state is SignedIn ? state.customer : null, profileRepository: _profileRepository),
          )
        ); 
      }
    );
  }  
}