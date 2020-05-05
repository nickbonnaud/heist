import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';

import 'bloc/profile_setup_screen_bloc.dart';
import 'widgets/profile_setup_screen_body.dart';

class ProfileSetupScreen extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: BlocProvider<ProfileSetupScreenBloc>(
        create: (context) => ProfileSetupScreenBloc()
          ..add(Init(customer: BlocProvider.of<CustomerBloc>(context).customer)),
        child: ProfileSetupScreenBody()
      )
    );
  }
}