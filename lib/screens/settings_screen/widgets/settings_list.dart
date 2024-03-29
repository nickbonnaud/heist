import 'package:flutter/material.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsList extends StatelessWidget {
  
  const SettingsList({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 15.h),
        ListTile(
          key: const Key("profileTileKey"),
          leading: Icon(
            Icons.person, 
            color: Theme.of(context).colorScheme.secondary,
            size: 35.sp
          ),
          title: Text(
            'Change Profile',
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              fontSize: 24.sp
            )
          ),
          onTap: () => Navigator.of(context).pushNamed(Routes.profile)
        ),
        ListTile(
          key: const Key("emailTileKey"),
          leading: Icon(
            Icons.email,
            color: Theme.of(context).colorScheme.secondary,
            size: 35.sp
          ),
          title: Text(
            'Change Email', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              fontSize: 24.sp
            )
          ),
          onTap: () => Navigator.of(context).pushNamed(Routes.email)
        ),
        ListTile(
          key: const Key("passwordTileKey"),
          leading: Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.secondary,
            size: 35.sp
          ),
          title: Text(
            'Change Password', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              fontSize: 24.sp
            )
          ),
          onTap: () => Navigator.of(context).pushNamed(Routes.password)
        ),
        ListTile(
          key: const Key("paymentTileKey"),
          leading: Icon(
            Icons.payment,
            color: Theme.of(context).colorScheme.secondary,
            size: 35.sp
          ),
          title: Text(
            'Change Payment', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              fontSize: 24.sp
            )
          ),
          onTap: () => print('show payment screen'),
        ),
        ListTile(
          key: const Key("tipTileKey"),
          leading: Icon(
            Icons.thumb_up,
            color: Theme.of(context).colorScheme.secondary,
            size: 35.sp
          ),
          title: Text(
            'Change Tips', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              fontSize: 24.sp
            )
          ),
          onTap: () => Navigator.of(context).pushNamed(Routes.tips)
        ),
        ListTile(
          key: const Key("signOutTileKey"),
          leading: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.secondary,
            size: 35.sp
          ),
          title: Text(
            'Logout', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              fontSize: 24.sp
            )
          ),
          onTap: () => Navigator.of(context).pushNamed(Routes.logout),
        ),
        SizedBox(height: 80.h)
      ],
    );
  }
}