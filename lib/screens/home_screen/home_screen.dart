import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/home_screen/bloc/side_menu_bloc.dart';
import 'package:heist/screens/home_screen/widgets/side_drawer.dart';
import 'package:heist/screens/map_screen/map_screen.dart';
import 'package:heist/screens/permission_screen/permission_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionsBloc, PermissionsState>(
      listener: (context, state) {
        if (!state.bleEnabled || !state.locationEnabled || !state.notificationEnabled || !state.beaconEnabled) {
          _showPermissionsModal(context: context, bluetoothEnabled: state.bleEnabled, locationEnabled: state.locationEnabled, notificationEnabled: state.notificationEnabled, beaconEnabled: state.beaconEnabled);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider<SideMenuBloc>(
          create: (BuildContext context) => SideMenuBloc(),
          child: SideDrawer(homeScreen: MapScreen()),
        ),
      ),
    );
  }

  void _showPermissionsModal({
    @required BuildContext context,
    @required bool bluetoothEnabled,
    @required bool locationEnabled,
    @required bool notificationEnabled,
    @required bool beaconEnabled
  }) {
    showPlatformModalSheet(
      context: context,
      builder: (_) => PlatformWidget(
        android: (_) => PermissionsScreen(
          isBluetoothEnabled: bluetoothEnabled,
          isLocationEnabled: locationEnabled,
          isNotificationEnabled: notificationEnabled,
          isBeaconEnabled: beaconEnabled,
        ),
        ios: (_) => PermissionsScreen(
          isBluetoothEnabled: bluetoothEnabled,
          isLocationEnabled: locationEnabled,
          isNotificationEnabled: notificationEnabled,
          isBeaconEnabled: beaconEnabled,
        )
      )
    ); 
  }
}