import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/models/customer/status.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/home_screen/bloc/side_menu_bloc.dart';
import 'package:heist/screens/home_screen/widgets/side_drawer.dart';
import 'package:heist/screens/map_screen/map_screen.dart';
import 'package:heist/screens/onboard_screen/onboard_screen.dart';
import 'package:heist/screens/permission_screen/permission_screen.dart';
import 'package:heist/screens/profile_screen/profile_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // _showAutoModals(context: context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<SideMenuBloc>(
        create: (BuildContext context) => SideMenuBloc(),
        child: SideDrawer(homeScreen: MapScreen()),
      ),
    );
  }

  void _showAutoModals({@required BuildContext context}) {
    Status status = BlocProvider.of<CustomerBloc>(context).customer.status;
    if (status.code <= 103 ) {
      _showOnboardModal(context: context);
    } else if (!BlocProvider.of<PermissionsBloc>(context).allPermissionsValid) {
      _showPermissionsModal(context: context);
    }
  }
  
  void _showOnboardModal({@required BuildContext context}) {
    showPlatformModalSheet(
      context: context,
      builder: (_) => OnboardScreen()
    );
  }
  
  void _showPermissionsModal({@required BuildContext context}) {
    showPlatformModalSheet(
      context: context,
      builder: (_) => PermissionsScreen()
    ); 
  }
}