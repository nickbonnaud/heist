import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SearchIdentifierModal extends StatelessWidget {
  final FocusNode _identifierNode = FocusNode();
  final String _hintText;

  SearchIdentifierModal({@required String hintText})
    : assert(hintText != null),
      _hintText = hintText;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: BottomModalAppBar(backgroundColor: Theme.of(context).colorScheme.scrollBackgroundLight),
      backgroundColor: Theme.of(context).colorScheme.scrollBackgroundLight,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            PlatformTextField(
              focusNode: _identifierNode,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getWidth(7),
              ),
              inputFormatters: [_createInputFormatter()],
              onSubmitted: (String identifier) => Navigator.of(context).pop(identifier),
              android: (_) => MaterialTextFieldData(
                decoration: InputDecoration(
                  hintText: _hintText,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.getWidth(7),
                    color: Theme.of(context).colorScheme.textOnLightDisabled
                  ),
                ),
              ),
              ios: (_) => CupertinoTextFieldData(
                placeholder: _hintText,
                placeholderStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.getWidth(7),
                  color: Theme.of(context).colorScheme.textOnLightDisabled
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