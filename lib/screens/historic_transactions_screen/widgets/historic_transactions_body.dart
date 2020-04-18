import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/ios_date_picker/bloc/ios_date_picker_bloc.dart';
import 'package:heist/global_widgets/ios_date_picker/ios_date_picker.dart';
import 'package:heist/global_widgets/material_date_picker/bloc/material_date_picker_bloc.dart';
import 'package:heist/global_widgets/material_date_picker/material_date_picker.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';

import 'historic_transactions_list.dart';

enum Options {
  all,
  businessName,
  date,
  transactionId
}

class HistoricTransactionsBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: DefaultAppBar(backgroundColor: Colors.grey.shade100, trailingWidget: _buildFilter(context)),
      body: Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: HistoricTransactionsList()
      ),
    );
  }

  Widget _buildFilter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: PopupMenuButton<Options>(
        onSelected: (Options result) => _filterOptions(result: result, context: context),
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
              title: 'Show All',
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
            value: Options.businessName,
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
              title: 'Find by transaction ID',
              icon: PlatformWidget(
                android: (_) => Icon(Icons.search, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF2F5,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage,
                ), size: SizeConfig.getWidth(7)),
              )
            ),
            value: Options.transactionId,
          ),
        ]
      ),
    );
  }

  void _filterOptions({@required Options result, @required BuildContext context}) {
    switch (result) {
      case Options.date:
        _searchByDate(context);
        break;
      default:
    }
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
      BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchTransactionsByDateRange(dateRange: range, reset: true));
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