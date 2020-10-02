import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/screens/permission_screen/widgets/permission_buttons/permission_buttons.dart';

import 'widgets/beacon_body.dart';
import 'widgets/bluetooth_body.dart';
import 'widgets/location_body.dart';
import 'widgets/notification_body.dart';


class PermissionCards extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionsBloc, PermissionsState>(
      builder: (context, state) {
        return Stack(
          children: [
            ..._createCards(context: context)
          ],
        );
      }
    );
  }

  List<Widget> _createCards({@required BuildContext context}) {
    List<Widget> cards = [];
    PermissionType.values.forEach((type) {
      cards.add(_createCard(context: context, permissionType: type));
    });
    return cards;
  }

  Widget _createCard({@required BuildContext context, @required PermissionType permissionType}) {
    List<PermissionType> currentInvalidPermissions = BlocProvider.of<PermissionsBloc>(context).invalidPermissions;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      top: currentInvalidPermissions.contains(permissionType) 
        ? currentInvalidPermissions.indexOf(permissionType) * 10.0 
        : MediaQuery.of(context).size.height,
      bottom: currentInvalidPermissions.contains(permissionType)
        ? 0 
        : - MediaQuery.of(context).size.height,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), 
              spreadRadius: 1.0,
              blurRadius: 5,
              offset: Offset(0, -5)
            )
          ]
        ),
        child: _createCardBody(permissionType: permissionType),
      )
    );
  }

  Widget _createCardBody({@required PermissionType permissionType}) {
    Widget body;
    switch (permissionType) {
      case PermissionType.bluetooth:
        body = BluetoothBody(permissionButtons: PermissionButtons(permission: PermissionType.bluetooth));
        break;
      case PermissionType.location:
        body = LocationBody(permissionButtons: PermissionButtons(permission: PermissionType.location));
        break;
      case PermissionType.notification:
        body = NotificationBody(permissionButtons: PermissionButtons(permission: PermissionType.notification));
        break;
      case PermissionType.beacon:
        body = BeaconBody(permissionButtons: PermissionButtons(permission: PermissionType.beacon));
        break;
    }
    return Padding(padding: EdgeInsets.only(bottom: 20), child: body);
  }
}