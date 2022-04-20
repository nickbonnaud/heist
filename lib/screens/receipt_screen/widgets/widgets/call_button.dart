import 'package:flutter/material.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CallButton extends StatelessWidget {
  final TransactionResource _transactionResource;

  const CallButton({required TransactionResource transactionResource, Key? key})
    : _transactionResource = transactionResource,
      super(key: key);
  
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
      label: Text(
        "Business",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 22.sp
        ),
      )
    );
  }
}