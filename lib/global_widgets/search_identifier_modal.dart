import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SearchIdentifierModal extends StatefulWidget {
  final String _hintText;

  SearchIdentifierModal({required String hintText})
    : _hintText = hintText;

  @override
  State<SearchIdentifierModal> createState() => _SearchIdentifierModalState();
}

class _SearchIdentifierModalState extends State<SearchIdentifierModal> {
  final FocusNode _identifierNode = FocusNode();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BottomModalAppBar(context: context, backgroundColor: Theme.of(context).colorScheme.scrollBackground),
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              focusNode: _identifierNode,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getWidth(7),
              ),
              decoration: InputDecoration(
                hintText: widget._hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.getWidth(7),
                  color: Theme.of(context).colorScheme.onPrimaryDisabled
                ),
              ),
              cursorColor: Theme.of(context).colorScheme.callToAction,
              inputFormatters: [_createInputFormatter()],
              onSubmitted: (String identifier) => Navigator.of(context).pop(identifier),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _identifierNode.dispose();
    super.dispose();
  }
  
  MaskTextInputFormatter _createInputFormatter() {
    return MaskTextInputFormatter(
      mask: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
      filter: {"x": RegExp(r'[A-Za-z0-9]')}
    );
  }
}