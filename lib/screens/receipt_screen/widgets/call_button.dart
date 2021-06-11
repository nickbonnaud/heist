import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CallButton extends StatelessWidget {
  final TransactionResource _transactionResource;

  CallButton({required TransactionResource transactionResource})
    : _transactionResource = transactionResource;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        Icons.phone, 
        color: Theme.of(context).colorScheme.onError
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
        backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.info)
      ),
      onPressed: () => launch("tel://${_transactionResource.business.profile.phone}"),
      label: BoldText3(text: "Business", context: context, color: Theme.of(context).colorScheme.onSecondary),
    );
  }
}