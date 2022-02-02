import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/screens/settings_screen/widgets/settings_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (BuildContext context) => DefaultAppBarBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DefaultAppBar(title: 'Settings'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SettingsList()
        ),
      ),
    );
  }
}