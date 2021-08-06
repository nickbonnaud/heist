import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/global_widgets/search_identifier_modal/widgets/search_identifier_body.dart';
import 'package:heist/themes/global_colors.dart';

import 'cubit/search_identifier_modal_cubit.dart';

class SearchIdentifierModal extends StatelessWidget {
  final String _hintText;

  SearchIdentifierModal({required String hintText})
    : _hintText = hintText;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BottomModalAppBar(context: context, backgroundColor: Theme.of(context).colorScheme.scrollBackground),
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: BlocProvider<SearchIdentifierModalCubit>(
          create: (_) => SearchIdentifierModalCubit(),
          child: SearchIdentifierBody(hintText: _hintText),
        ),
      ),
    );
  }
}