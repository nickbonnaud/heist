import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/screens/settings_screen/widgets/settings_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {

  const SettingsScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (BuildContext context) => DefaultAppBarBloc(),
      child: Scaffold(
        appBar: const DefaultAppBar(title: 'Settings'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const SettingsList()
        ),
      ),
    );
  }
}