import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:heist/screens/receipt_screen/widgets/keep_open_button/bloc/keep_open_button_bloc.dart';
import 'package:heist/screens/receipt_screen/widgets/report_issue_button.dart';
import 'package:heist/themes/global_colors.dart';

import 'call_button.dart';
import 'change_issue_button.dart';
import 'keep_open_button/keep_open_button.dart';
import 'pay_button/bloc/pay_button_bloc.dart';
import 'pay_button/pay_button.dart';
import 'purchased_item_widget.dart';

class ReceiptScreenBody extends StatelessWidget {
  final bool _showAppBar;
  final TransactionRepository _transactionRepository = TransactionRepository();

  ReceiptScreenBody({bool showAppBar = true})
    : _showAppBar = showAppBar;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptScreenBloc, ReceiptScreenState>(
      builder: (context, state) {
        TransactionResource _transactionResource = state.transactionResource;
        return Scaffold(
          body: _createScrollableContent(context: context, transactionResource: _transactionResource),
          bottomNavigationBar: state.isButtonVisible ? BlocProvider<PayButtonBloc>(
            create: (_) => PayButtonBloc(
              transactionRepository: _transactionRepository,
              transactionResource: _transactionResource
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: _createFooterButtons(receiptState: state, transactionResource: _transactionResource) 
            ),
          ) : null
        );
      }
    ); 
  }

  Widget _createScrollableContent({@required BuildContext context, @required TransactionResource transactionResource}) {
    if (_showAppBar) {
      return CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          BottomModalAppBar(
            backgroundColor: Theme.of(context).colorScheme.topAppBar,
            isSliver: true,
            trailingWidget: _trailingWidget(transactionResource: transactionResource)
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 16, right: 16),
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
  
  List<Widget> _buildBody({@required BuildContext context, @required TransactionResource transactionResource}) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: <Widget>[
            CachedAvatarHero(
              url: transactionResource.business.photos.logo.smallUrl,
              radius: 7,
              tag: transactionResource.transaction.identifier
            ),
            SizedBox(width: SizeConfig.getWidth(2)),
            Expanded(
              child: BoldText2(
                text: transactionResource.business.profile.name,
                context: context,
              ),
            ),
            Text2(
              text: transactionResource.transaction.billUpdatedAt,
              context: context,
              color: Theme.of(context).colorScheme.onPrimarySubdued,
            )
          ],
        ),
      ),
      if (transactionResource.issue != null && !transactionResource.issue.resolved)
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BoldText3(text: "Issue reported", context: context, color: Theme.of(context).colorScheme.info),
              _numberWarningsLeft(context: context, transactionResource: transactionResource)
            ],
          )
        ),
      SizedBox(height: SizeConfig.getHeight(3)),
      ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return PurchasedItemWidget(purchasedItem: transactionResource.transaction.purchasedItems[index]);
        },
        itemCount: transactionResource.transaction.purchasedItems.length,
        separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1),
      ),
      Divider(thickness: 1),
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height:SizeConfig.getHeight(3)),
            _createFooterRow(context: context, title: "Subtotal", value: transactionResource.transaction.netSales),
            SizedBox(height:SizeConfig.getHeight(1)),
            _createFooterRow(context: context, title: "Tax", value: transactionResource.transaction.tax),
            if (transactionResource.transaction.tip != 0)
              SizedBox(height:SizeConfig.getHeight(1)),
            if (transactionResource.transaction.tip != 0)
              _createFooterRow(context: context, title: "Tip", value: transactionResource.transaction.tip),
            if (transactionResource.refunds.length > 0)
              SizedBox(height: SizeConfig.getHeight(1)),
            if (transactionResource.refunds.length > 0)
              _createRefundRow(context: context, transactionResource: transactionResource),
            SizedBox(height:SizeConfig.getHeight(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BoldText2(text: "Total", context: context),
                BoldText2(text: Currency.create(cents: _setTotal(transactionResource: transactionResource)), context: context),
              ],
            ),
          ],
        ),
      ),
      Divider(thickness: 2),
      Padding(
        padding: EdgeInsets.only(
          left: 16, 
          top: SizeConfig.getHeight(1)
        ),
        child: Text2(
          text: "Purchase Location", 
          context: context, 
          color: Theme.of(context).colorScheme.onPrimarySubdued
        ),
      ),
      SizedBox(height: SizeConfig.getHeight(1)),
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: SizeConfig.getWidth(50),
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
        ),
      ),
      SizedBox(height: SizeConfig.getHeight(2)),
      Divider(thickness: 2),
      SizedBox(height: SizeConfig.getHeight(2)),
      Center(
        child: Text3(
          text: "Transaction ID: ${transactionResource.transaction.identifier}",
          context: context, 
          color: Theme.of(context).colorScheme.onPrimarySubdued
        ),
      ),
      SizedBox(height: SizeConfig.getHeight(2)),
    ];
  }
  
  Widget _numberWarningsLeft({@required BuildContext context, @required TransactionResource transactionResource}) {
    if (transactionResource.issue.warningsSent == 3) {
      return Text2(text: "Response required to avoid autopay", context: context, color: Theme.of(context).colorScheme.danger);
    } else if (transactionResource.issue.warningsSent > 0) {
      return Text2(text: "${3 - transactionResource.issue.warningsSent} warnings left", context: context, color: Theme.of(context).colorScheme.warning);
    } else {
      return Container();
    }
  }
  
  Widget _createFooterButtons({@required ReceiptScreenState receiptState, @required TransactionResource transactionResource}) {
    int statusCode = receiptState.transactionResource.transaction.status.code;
    if (statusCode == 105) {
      return BlocBuilder<ActiveLocationBloc, ActiveLocationState>(
        builder: (context, state) {
          int index = state.activeLocations.indexWhere((ActiveLocation activeLocation) {
            return activeLocation.transactionIdentifier == transactionResource.transaction.identifier;
          });

          if (index < 0) {
            return Row(children: <Widget>[
              Expanded(
                child: BlocProvider<KeepOpenButtonBloc>(
                  create: (BuildContext context) => KeepOpenButtonBloc(
                    transactionRepository: _transactionRepository
                  ),
                  child: KeepOpenButton(transactionResource: transactionResource),
                )
              ),
              SizedBox(width: 20.0),
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
      return Row(children: <Widget>[
        Expanded(
          child: CallButton(transactionResource: transactionResource)
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: PayButton(transactionResource: transactionResource)
        )
      ]);
    } else {
      return PayButton(transactionResource: transactionResource);
    }
  }

  int _setTotal({@required TransactionResource transactionResource}) {
    if (transactionResource.refunds.length > 0) {
      return transactionResource.transaction.total - transactionResource.refunds.fold(0, (total, refund) => total + refund.total);
    }
    return transactionResource.transaction.total;
  }

  Widget _createRefundRow({@required BuildContext context, @required TransactionResource transactionResource}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text2(
          text: "Total Refund", 
          context: context, 
          color: Theme.of(context).colorScheme.info
        ),
        Text2(
          text: "(${Currency.create(cents: transactionResource.refunds.fold(0, (total, refund) => total + refund.total))})", 
          context: context, 
          color: Theme.of(context).colorScheme.info
        ),
      ],
    );
  }

  Widget _createFooterRow({@required BuildContext context, @required String title, @required int value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text2(
          text: title, 
          context: context, 
        ),
        Text2(
          text: Currency.create(cents: value), 
          context: context,
        )
      ],
    );
  }

  Widget _trailingWidget({@required TransactionResource transactionResource}) {
    int code = transactionResource.transaction.status.code;
    Widget trailing;
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
        trailing = ChangeIssueButton(transaction: transactionResource);
        break;
    }
    return trailing;
  }
}