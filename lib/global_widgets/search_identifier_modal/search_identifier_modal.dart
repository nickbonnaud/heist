import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/global_widgets/search_identifier_modal/widgets/search_identifier_body.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/search_identifier_modal_bloc.dart';

class SearchIdentifierModal extends StatelessWidget {
  final String _hintText;

  const SearchIdentifierModal({required String hintText, Key? key})
    : _hintText = hintText,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BottomModalAppBar(backgroundColor: Theme.of(context).colorScheme.scrollBackground),
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: BlocProvider<SearchIdentifierModalBloc>(
          create: (_) => SearchIdentifierModalBloc(),
          child: SearchIdentifierBody(hintText: _hintText),
        ),
      ),
    );
  }
}