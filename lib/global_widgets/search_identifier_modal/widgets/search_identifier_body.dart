import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/search_identifier_modal/cubit/search_identifier_modal_cubit.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchIdentifierBody extends StatefulWidget {
  final String _hintText;

  const SearchIdentifierBody({required String hintText, Key? key})
    : _hintText = hintText,
      super(key: key);

  @override
  State<SearchIdentifierBody> createState() => _SearchIdentifierBodyState();
}

class _SearchIdentifierBodyState extends State<SearchIdentifierBody> {
  final FocusNode _identifierNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  late MaskTextInputFormatter _inputFormatter;
  
  @override
  void initState() {
    super.initState();
    _inputFormatter = _createInputFormatter();
    _controller.addListener(_onInputChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        BlocBuilder<SearchIdentifierModalCubit, bool>(
          builder: (context, isUuidValid) {
            return TextFormField(
              key: const Key("identifierFieldKey"),
              focusNode: _identifierNode,
              controller: _controller,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28.sp,
              ),
              decoration: InputDecoration(
                hintText: widget._hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                  color: Theme.of(context).colorScheme.onPrimaryDisabled
                ),
              ),
              cursorColor: Theme.of(context).colorScheme.callToAction,
              inputFormatters: [_inputFormatter],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) => !isUuidValid && _controller.text.isNotEmpty
                ? "Invalid ID"
                : null,
              onFieldSubmitted: (String identifier) => Navigator.of(context).pop(isUuidValid ? identifier : null),
            );
          }
        )
      ],
    );
  }

  @override
  void dispose() {
    _identifierNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  MaskTextInputFormatter _createInputFormatter() {
    return MaskTextInputFormatter(
      mask: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
      filter: {"x": RegExp(r'[A-Za-z0-9]')}
    );
  }

  void _onInputChanged() {
    context.read<SearchIdentifierModalCubit>().inputChanged(uuid: _controller.text);
  }
}