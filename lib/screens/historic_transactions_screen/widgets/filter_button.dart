import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/material_date_picker/bloc/material_date_picker_bloc.dart';
import 'package:heist/global_widgets/material_date_picker/material_date_picker.dart';
import 'package:heist/global_widgets/search_business_name_modal.dart';
import 'package:heist/global_widgets/search_identifier_modal.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';
import 'package:heist/themes/global_colors.dart';

enum Options {
  all,
  businessName,
  date,
  transactionId
}

class FilterButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: PopupMenuButton<Options>(
        onSelected: (Options result) => _filterOptions(result: result, context: context),
        icon: PlatformWidget(
          android: (_) => Icon(
            Icons.filter_list,
            size: SizeConfig.getWidth(10),
            color: Theme.of(context).colorScheme.topAppBarIconLight,
          ),
          ios: (_) => Icon(
            IconData(
              0xF38B,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage,
            ),
            size: SizeConfig.getWidth(10),
            color: Theme.of(context).colorScheme.topAppBarIconLight,
          ),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
          PopupMenuItem<Options>(
            child: _createTile(
              context: context,
              title: 'Show all',
              icon: PlatformWidget(
                android: (_) => Icon(
                  Icons.receipt, 
                  size: SizeConfig.getWidth(7),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                ios: (_) => Icon(
                  IconData(
                    0xF472,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  size: SizeConfig.getWidth(7),
                  color: Theme.of(context).colorScheme.secondary
                ),
              )
            ),
            value: Options.all,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              context: context,
              title: 'Find by business name',
              icon: PlatformWidget(
                android: (_) => Icon(Icons.business, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF3EE,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage
                ),
                size: SizeConfig.getWidth(7),
                color: Theme.of(context).colorScheme.secondary),
              )
            ),
            value: Options.businessName,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              context: context,
              title: 'Search by date',
              icon: PlatformWidget(
                android: (_) => Icon(Icons.event, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF2D1,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage
                ),
                size: SizeConfig.getWidth(7),
                color: Theme.of(context).colorScheme.secondary),
              )
            ),
            value: Options.date,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              context: context,
              title: 'Find by transaction ID',
              icon: PlatformWidget(
                android: (_) => Icon(Icons.search, size: SizeConfig.getWidth(7)),
                ios: (_) => Icon(IconData(
                  0xF2F5,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage,
                ),
                size: SizeConfig.getWidth(7),
                color: Theme.of(context).colorScheme.secondary),
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
      case Options.businessName:
        _searchByName(context);
        break;
      case Options.transactionId:
        _searchByTransactionId(context);
        break;
      case Options.all:
        _fetchAllTransactions(context);
        break;
    }
  }

  void _fetchAllTransactions(BuildContext context) {
    BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchHistoricTransactions(reset: true));
  }
  
  void _searchByTransactionId(BuildContext context) async {
    String identifier = await showPlatformModalSheet(
      context: context,
      builder: (_) => SearchIdentifierModal(hintText: "Transaction ID")
    );
    if (identifier != null) {
      BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchTransactionByIdentifier(identifier: identifier, reset: true));
    }
  }

  void _searchByName(BuildContext context) async {
    Business business = await showPlatformModalSheet(
      context: context,
      builder: (_) => SearchBusinessNameModal()
    );
    if (business != null) {
      BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchTransactionsByBusiness(identifier: business.identifier, reset: true));
    }
  }
  
  void _searchByDate(BuildContext context) async {
    DateRange range;
    range = await showPlatformModalSheet(
        context: context,
        builder: (_) => BlocProvider<MaterialDatePickerBloc>(
          create: (BuildContext context) => MaterialDatePickerBloc(),
          child: MaterialDatePicker(),
        )
      );
    if (range != null && range.startDate != null && range.endDate != null) {
      BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchTransactionsByDateRange(dateRange: range, reset: true));
    }
  }

  ListTile _createTile({@required BuildContext context, @required String title, @required Widget icon}) {
    return ListTile(
      leading: icon,
      title: _createTitle(context: context, title: title),
    );
  }
  
  Widget _createTitle({@required BuildContext context, @required String title}) {
    return BoldText5(text: title, context: context);
  }
}