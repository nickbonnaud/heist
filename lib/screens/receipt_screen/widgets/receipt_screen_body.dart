import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/change_issue_button.dart';
import 'widgets/keep_open_button/bloc/keep_open_button_bloc.dart';
import 'widgets/keep_open_button/keep_open_button.dart';
import 'widgets/pay_button/bloc/pay_button_bloc.dart';
import 'widgets/pay_button/pay_button.dart';
import 'widgets/purchased_item_widget.dart';
import 'widgets/call_button.dart';
import 'widgets/report_issue_button.dart';

class ReceiptScreenBody extends StatelessWidget {
  final bool _showAppBar;
  final TransactionRepository _transactionRepository;
  final OpenTransactionsBloc _openTransactionsBloc;
  final TransactionIssueRepository _transactionIssueRepository;

  ReceiptScreenBody({
    required TransactionRepository transactionRepository,
    required OpenTransactionsBloc openTransactionsBloc,
    required TransactionIssueRepository transactionIssueRepository,
    bool showAppBar: true
  })
    : _transactionRepository = transactionRepository,
      _openTransactionsBloc = openTransactionsBloc,
      _transactionIssueRepository = transactionIssueRepository,
      _showAppBar = showAppBar;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptScreenBloc, ReceiptScreenState>(
      builder: (context, state) {
        return Scaffold(
          body: _createScrollableContent(context: context, transactionResource: state.transactionResource),
          bottomNavigationBar: state.isButtonVisible 
            ? BlocProvider<PayButtonBloc>(
                create: (_) => PayButtonBloc(
                  transactionRepository: _transactionRepository,
                  transactionResource: state.transactionResource,
                  openTransactionsBloc: _openTransactionsBloc,
                  receiptScreenBloc: BlocProvider.of<ReceiptScreenBloc>(context)
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                  child: _createFooterButtons(receiptState: state, transactionResource: state.transactionResource) 
                ),
              )
            : null
        );
      }
    ); 
  }

  Widget _createScrollableContent({required BuildContext context, required TransactionResource transactionResource}) {
    if (_showAppBar) {
      return CustomScrollView(
        shrinkWrap: true,
        slivers: [
          BottomModalAppBar(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.topAppBar,
            isSliver: true,
            trailingWidget: _trailingWidget(transactionResource: transactionResource)
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: _buildBody(context: context, transactionResource: transactionResource)
              ),
            ),
          )
        ],
      );
    } else {
      return ListView(
        shrinkWrap: true,
        children: _buildBody(context: context, transactionResource: transactionResource),
      );
    }
  }
  
  List<Widget> _buildBody({required BuildContext context, required TransactionResource transactionResource}) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: _receiptTop(context: context, transactionResource: transactionResource),
      ),
      _warning(context: context, transactionResource: transactionResource),
      SizedBox(height: 5.h),
      _purchasedItems(transactionResource: transactionResource),
      Divider(thickness: 1),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: _receiptBottom(context: context, transactionResource: transactionResource),
      ),
      Divider(thickness: 2),
      Padding(
        padding: EdgeInsets.only(
          left: 16.w, 
          top: 10.h
        ),
        child: Text(
          "Purchase Location",
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.onPrimarySubdued
          ),
        )
      ),
      SizedBox(height: 10.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: _purchasedLocationMap(transactionResource: transactionResource),
      ),
      SizedBox(height: 20.h),
      Divider(thickness: 2),
      SizedBox(height: 20.h),
      Center(
        child: Text(
          "ID: ${transactionResource.transaction.identifier}",
          style: TextStyle(
            fontSize: 16.sp,
            color: Theme.of(context).colorScheme.onPrimarySubdued
          ),
        )
      ),
      SizedBox(height: 20.h),
    ];
  }
  
  Widget _receiptTop({required BuildContext context, required TransactionResource transactionResource}) {
    return Row(
      children: [
        CachedAvatarHero(
          url: transactionResource.business.photos.logo.smallUrl,
          radius: 55.sp,
          tag: transactionResource.transaction.identifier
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            children: [
              Text(
                transactionResource.business.profile.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp
                ),
              ),
              Text(
                DateFormatter.toStandardDate(date: transactionResource.transaction.billUpdatedAt),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                ),
              )
            ],
          )
        ),
      ],
    );
  }

  Widget _warning({required BuildContext context, required TransactionResource transactionResource}) {
    if (transactionResource.issue != null && !transactionResource.issue!.resolved) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Issue reported",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp,
                  color: Theme.of(context).colorScheme.info
                ),
              ),
              _numberWarningsLeft(context: context, transactionResource: transactionResource)
            ],
          ),
        )
      );
    } else {
      return Container();
    }
  }

  Widget _purchasedItems({required TransactionResource transactionResource}) {
    return ListView.separated(
      key: Key("receiptBodyWithAppBarKey"),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return PurchasedItemWidget(purchasedItem: transactionResource.transaction.purchasedItems[index], index: index);
      },
      itemCount: transactionResource.transaction.purchasedItems.length,
      separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1),
    );
  }

  Widget _receiptBottom({required BuildContext context, required TransactionResource transactionResource}) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _createFooterRow(context: context, title: "Subtotal", value: transactionResource.transaction.netSales),
        SizedBox(height:10.h),
        _createFooterRow(context: context, title: "Tax", value: transactionResource.transaction.tax),
        if (transactionResource.transaction.tip != 0)
          SizedBox(height: 10.h),
        if (transactionResource.transaction.tip != 0)
          _createFooterRow(context: context, title: "Tip", value: transactionResource.transaction.tip),
        if (transactionResource.refunds.length > 0)
          SizedBox(height: 10.h),
        if (transactionResource.refunds.length > 0)
          _createRefundRow(context: context, transactionResource: transactionResource),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,
              ),
            ),
            Text(
              Currency.create(cents: _setTotal(transactionResource: transactionResource)),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _purchasedLocationMap({required TransactionResource transactionResource}) {
    return Container(
      height: 180.w,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(transactionResource.business.location.geo.lat, transactionResource.business.location.geo.lng),
          zoom: 16.0
        ),
        myLocationButtonEnabled: false,
        markers: [Marker(
          markerId: MarkerId(transactionResource.business.identifier),
          position: LatLng(transactionResource.business.location.geo.lat, transactionResource.business.location.geo.lng),
        )].toSet(),
      ),
    );
  }
  
  Widget _numberWarningsLeft({required BuildContext context, required TransactionResource transactionResource}) {
    if (transactionResource.issue!.warningsSent == 3) {
      return Text(
        "Response required to avoid autopay!",
        style: TextStyle(
          fontSize: 18.sp,
          color: Theme.of(context).colorScheme.danger
        ),
      );
    } else if (transactionResource.issue!.warningsSent > 0) {
      return Text(
        "${3 - transactionResource.issue!.warningsSent} warnings left!",
        style: TextStyle(
          fontSize: 18.sp,
          color: Theme.of(context).colorScheme.danger
        ),
      ); 
    } else {
      return Container();
    }
  }
  
  Widget _createFooterButtons({required ReceiptScreenState receiptState, required TransactionResource transactionResource}) {
    int statusCode = receiptState.transactionResource.transaction.status.code;
    if (statusCode == 105) {
      return BlocBuilder<ActiveLocationBloc, ActiveLocationState>(
        builder: (context, state) {
          int index = state.activeLocations.indexWhere((ActiveLocation activeLocation) {
            return activeLocation.transactionIdentifier == transactionResource.transaction.identifier;
          });

          if (index < 0) {
            return Row(children: [
              Expanded(
                child: BlocProvider<KeepOpenButtonBloc>(
                  create: (BuildContext context) => KeepOpenButtonBloc(
                    transactionRepository: _transactionRepository,
                    openTransactionsBloc: _openTransactionsBloc,
                    receiptScreenBloc: BlocProvider.of<ReceiptScreenBloc>(context)
                  ),
                  child: KeepOpenButton(transactionResource: transactionResource),
                )
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: PayButton(transactionResource: transactionResource)
              )
            ]);
          } else {
            return PayButton(transactionResource: transactionResource);
          }
        }
      );
    } else if (statusCode >= 500) {
      return Row(children: [
        Expanded(
          child: CallButton(transactionResource: transactionResource)
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: PayButton(transactionResource: transactionResource)
        )
      ]);
    } else {
      return PayButton(transactionResource: transactionResource);
    }
  }

  int _setTotal({required TransactionResource transactionResource}) {
    if (transactionResource.refunds.length > 0) {
      return transactionResource.transaction.total - transactionResource.refunds.fold(0, (total, refund) => total + refund.total);
    }
    return transactionResource.transaction.total;
  }

  Widget _createRefundRow({required BuildContext context, required TransactionResource transactionResource}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Refund",
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.info
          ),
        ),
        Text(
          "(${Currency.create(cents: transactionResource.refunds.fold(0, (total, refund) => total + refund.total))})",
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.info
          ),
        )
      ],
    );
  }

  Widget _createFooterRow({required BuildContext context, required String title, required int value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
        Text(
          Currency.create(cents: value), 
          style: TextStyle(
            fontSize: 18.sp,
          ),
        )
      ],
    );
  }

  Widget? _trailingWidget({required TransactionResource transactionResource}) {
    int code = transactionResource.transaction.status.code;
    Widget? trailing;
    switch (code) {
      case 103:
      case 104:
      case 200:
        trailing = null;
        break;
      case 100:
      case 101:
      case 1020:
      case 1021:
      case 1022:
      case 502:
        trailing = ReportIssueButton(transaction: transactionResource);
        break;
      case 500:
      case 501:
      case 503:
        trailing = ChangeIssueButton(transaction: transactionResource, transactionIssueRepository: _transactionIssueRepository);
        break;
    }
    return trailing;
  }
}