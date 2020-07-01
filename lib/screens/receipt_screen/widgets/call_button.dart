import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class CallButton extends StatelessWidget {
  final TransactionResource _transactionResource;

  CallButton({@required TransactionResource transactionResource})
    : assert (transactionResource != null),
      _transactionResource = transactionResource;
  
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: PlatformWidget(
        android: (_) => Icon(Icons.phone, color: Colors.white),
        ios: (_) => Icon(IconData(0xF4B9,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage
        ), color: Colors.white),
      ),
      color: Colors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () => launch("tel://${_transactionResource.business.profile.phone}"),
      label: BoldText(text: "Business", size: SizeConfig.getWidth(6), color: Colors.white),
    );
  }
}