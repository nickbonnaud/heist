import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/search_identifier_modal_bloc.dart';

class SearchIdentifierBody extends StatelessWidget {
  final MaskTextInputFormatter _inputFormatter = MaskTextInputFormatter(
    mask: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
    filter: {"x": RegExp(r'[A-Za-z0-9]')}
  );

  final String _hintText;

  SearchIdentifierBody({required String hintText, Key? key})
    : _hintText = hintText,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        BlocBuilder<SearchIdentifierModalBloc, SearchIdentifierModalState>(
          builder: (context, state) {
            return TextFormField(
              key: const Key("identifierFieldKey"),
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28.sp,
              ),
              decoration: InputDecoration(
                hintText: _hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                  color: Theme.of(context).colorScheme.onPrimaryDisabled
                ),
              ),
              cursorColor: Theme.of(context).colorScheme.callToAction,
              inputFormatters: [_inputFormatter],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) => !state.isUUIDValid && state.uuid.isNotEmpty
                ? "Invalid ID"
                : null,
              onChanged: (uuid) => _onInputChanged(context: context, uuid: uuid),
              onFieldSubmitted: (_) => Navigator.of(context).pop(state.isUUIDValid ? state.uuid : null),
            );
          }
        )
      ],
    );
  }

  void _onInputChanged({required BuildContext context, required String uuid}) {
    BlocProvider.of<SearchIdentifierModalBloc>(context).add(UUIDChanged(uuid: uuid));
  }
}