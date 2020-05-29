import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/map_screen/widgets/bottom_pane/open_transactions_list.dart';

import 'active_location_list.dart';
import 'customer_welcome_message.dart';

class BottomPane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), 
                spreadRadius: 4.0,
                blurRadius: 5,
                offset: Offset(0, -5)
              )
            ],
          )
        ),
        SizedBox(height: SizeConfig.getHeight(2)),
        CustomerWelcomeMessage(),
        SizedBox(height: SizeConfig.getHeight(1)),
        OpenTransactionsList(),
        ActiveLocationList(),
      ],
    );
  }
}