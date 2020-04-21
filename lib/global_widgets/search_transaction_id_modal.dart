import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SearchTransactionIdModal extends StatelessWidget {
  final FocusNode _transactionIdNode = FocusNode();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: BottomModalAppBar(backgroundColor: Colors.grey.shade100),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            PlatformTextField(
              focusNode: _transactionIdNode,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getWidth(6),
              ),
              inputFormatters: [_createInputFormatter()],
              onSubmitted: (String identifier) => Navigator.of(context).pop(identifier),
              android: (_) => MaterialTextFieldData(
                decoration: InputDecoration(
                  hintText: "Transaction ID",
                  hintStyle: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.getWidth(6)
                  ),
                ),
              ),
              ios: (_) => CupertinoTextFieldData(
                placeholder: "Transaction ID",
                placeholderStyle: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.getWidth(6),
                  color: CupertinoColors.placeholderText
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  MaskTextInputFormatter _createInputFormatter() {
    return MaskTextInputFormatter(
      mask: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
      filter: {"x": RegExp(r'[A-Za-z0-9]')}
    );
  }
}