import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/ios_date_picker/bloc/ios_date_picker_bloc.dart';
import 'package:heist/global_widgets/ios_date_picker/ios_date_picker.dart';
import 'package:heist/global_widgets/material_date_picker/bloc/material_date_picker_bloc.dart';
import 'package:heist/global_widgets/material_date_picker/material_date_picker.dart';
import 'package:heist/global_widgets/search_business_name_modal.dart';
import 'package:heist/global_widgets/search_identifier_modal.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/refunds_screen/bloc/refunds_screen_bloc.dart';

enum Options {
  all,
  date,
  refundId,
  business,
  transactionId,
}

class FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: PopupMenuButton<Options>(
        onSelected: (Options result) => _filterSelection(result: result, context: context),
        icon: PlatformWidget(
          android: (_) => Icon(
            Icons.filter_list,
            size: SizeConfig.getWidth(10),
            color: Colors.black,
          ),
          ios: (_) => Icon(
            IconData(
              0xF38B,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage,
            ),
            size: SizeConfig.getWidth(10),
            color: Colors.black,
          ),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
          PopupMenuItem<Options>(
            child: _createTile(
              title: 'Show all', 
              icon: PlatformWidget(
                android: (_) => Icon(Icons.receipt, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF472,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage
                ), size: SizeConfig.getWidth(7)),
              )
            ),
            value: Options.all,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              title: 'Search by date',
              icon: PlatformWidget(
                android: (_) => Icon(Icons.event, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF2D1,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage
                ), size: SizeConfig.getWidth(7)),
              )
            ),
            value: Options.date,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              title: 'Find by refund ID',
              icon: PlatformWidget(
                android: (_) => Icon(Icons.search, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF2F5,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage,
                ), size: SizeConfig.getWidth(7)),
              )
            ),
            value: Options.refundId,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              title: 'Find by business name',
              icon: PlatformWidget(
                android: (_) => Icon(Icons.business, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF3EE,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage
                ), size: SizeConfig.getWidth(7)),
              )
            ),
            value: Options.business,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              title: 'Find by transaction ID',
              icon: PlatformWidget(
                android: (_) => Icon(Icons.assignment, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF391,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage
                ), size: SizeConfig.getWidth(7)),
              )
            ),
            value: Options.transactionId,
          ),
        ]
      ),
    );
  }

  void _filterSelection({@required Options result, @required BuildContext context}) {
    switch (result) {
      case Options.all:
        _fetchAllRefunds(context);
        break;
      case Options.date:
        _searchByDate(context);
        break;
      case Options.refundId:
        _searchByRefundId(context);
        break;
      case Options.business:
        _searchByName(context);
        break;
      case Options.transactionId:
        _searchByTransactionId(context);
        break;
    }
  }

  void _fetchAllRefunds(BuildContext context) {
    BlocProvider.of<RefundsScreenBloc>(context).add(FetchAllRefunds());
  }

  void _searchByDate(BuildContext context) async {
    DateRange range;
    if (Platform.isIOS) {
      range = await showPlatformModalSheet(
        context: context,
        builder: (_) => BlocProvider<IosDatePickerBloc>(
          create: (BuildContext context) => IosDatePickerBloc(),
          child: IosDatePicker(),
        )
      );
    } else {
      range = await showPlatformModalSheet(
        context: context,
        builder: (_) => BlocProvider<MaterialDatePickerBloc>(
          create: (BuildContext context) => MaterialDatePickerBloc(),
          child: MaterialDatePicker(),
        )
      );
    }
    if (range != null && range.startDate != null && range.endDate != null) {
      BlocProvider.of<RefundsScreenBloc>(context).add(FetchRefundsByDateRange(dateRange: range, reset: true));
    }
  }

  void _searchByRefundId(BuildContext context) async {
    String identifier = await showPlatformModalSheet(
      context: context, 
      builder: (_) => SearchIdentifierModal(hintText: "Refund ID")
    );
    if (identifier != null) {
      BlocProvider.of<RefundsScreenBloc>(context).add(FetchRefundByIdentifier(identifier: identifier, reset: true));
    }
  }

  void _searchByName(BuildContext context) async {
    Business business = await showPlatformModalSheet(
      context: context, 
      builder: (_) => SearchBusinessNameModal()
    );
    if (business != null) {
       BlocProvider.of<RefundsScreenBloc>(context).add(FetchRefundByBusiness(identifier: business.identifier, reset: true));
    }
  }

  void _searchByTransactionId(BuildContext context) async {
    String identifier = await showPlatformModalSheet(
      context: context, 
      builder: (_) => SearchIdentifierModal(hintText: "Transaction ID")
    );
    if (identifier != null) {
      BlocProvider.of<RefundsScreenBloc>(context).add(FetchRefundByTransaction(identifier: identifier, reset: true));
    }
  }

  ListTile _createTile({@required String title, @required Widget icon}) {
    return ListTile(
      leading: icon,
      title: _createTitle(title: title),
    );
  }

  Widget _createTitle({@required String title}) {
    return BoldText(text: title, size: SizeConfig.getWidth(4), color: Colors.black);
  }
}