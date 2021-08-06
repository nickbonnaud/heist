import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/search_business_name_bloc.dart';
import 'widgets/search_business_name_body.dart';

class SearchBusinessNameModal extends StatelessWidget {
  final BusinessRepository _businessRepository;

  const SearchBusinessNameModal({required BusinessRepository businessRepository})
    : _businessRepository = businessRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BottomModalAppBar(context: context, backgroundColor: Theme.of(context).colorScheme.scrollBackground),
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: BlocProvider<SearchBusinessNameBloc>(
          create: (_) => SearchBusinessNameBloc(businessRepository: _businessRepository),
          child: SearchBusinessNameBody(),
        ),
      ),
    );
  }
}