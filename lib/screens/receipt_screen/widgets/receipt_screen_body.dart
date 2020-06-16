import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:heist/screens/receipt_screen/widgets/report_issue_button.dart';

import 'change_issue_button.dart';
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
          appBar: _showAppBar ? BottomModalAppBar(backgroundColor: Colors.white10, trailingWidget: _trailingWidget(transactionResource: _transactionResource)) : null,
          body: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(_transactionResource.business.photos.logo.smallUrl),
                      radius: SizeConfig.getWidth(7),
                    ),
                    SizedBox(width: SizeConfig.getWidth(2)),
                    Expanded(
                      child: BoldText(
                        text: _transactionResource.business.profile.name,
                        size: SizeConfig.getWidth(7), 
                        color: Colors.black
                      ),
                    ),
                    NormalText(
                      text: _transactionResource.transaction.billUpdatedAt,
                      size: SizeConfig.getWidth(5),
                      color: Colors.black54,
                    )
                  ],
                ),
              ),
              if (_transactionResource.issue != null)
                Center(
                  child: BoldText(text: "Issue reported", size: SizeConfig.getWidth(5), color: Colors.red)
                ),
              SizedBox(height: SizeConfig.getHeight(3)),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return PurchasedItemWidget(purchasedItem: _transactionResource.transaction.purchasedItems[index]);
                },
                itemCount: _transactionResource.transaction.purchasedItems.length,
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
                    _createFooterRow("Subtotal", _transactionResource.transaction.netSales),
                    SizedBox(height:SizeConfig.getHeight(1)),
                    _createFooterRow("Tax", _transactionResource.transaction.tax),
                    if (_transactionResource.transaction.tip != 0)
                      SizedBox(height:SizeConfig.getHeight(1)),
                    if (_transactionResource.transaction.tip != 0)
                      _createFooterRow("Tip", _transactionResource.transaction.tip),
                    if (_transactionResource.refunds.length > 0)
                      SizedBox(height: SizeConfig.getHeight(1)),
                    if (_transactionResource.refunds.length > 0)
                      _createRefundRow(transactionResource: _transactionResource),
                    SizedBox(height:SizeConfig.getHeight(3)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        BoldText(text: "Total", size: SizeConfig.getWidth(7), color: Colors.black),
                        BoldText(text: Currency.create(cents: _setTotal(transactionResource: _transactionResource)), size: SizeConfig.getWidth(7), color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(thickness: 2),
              Padding(padding: EdgeInsets.only(left: 16, top: SizeConfig.getHeight(3)),
              child: BoldText(text: "Purchase Location", size: SizeConfig.getWidth(4), color: Colors.black54),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  height: SizeConfig.getWidth(50),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_transactionResource.business.location.geo.lat, _transactionResource.business.location.geo.lng),
                      zoom: 16.0
                    ),
                    myLocationButtonEnabled: false,
                    markers: [Marker(
                      markerId: MarkerId(_transactionResource.business.identifier),
                      position: LatLng(_transactionResource.business.location.geo.lat, _transactionResource.business.location.geo.lng),
                    )].toSet(),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.getHeight(2)),
              Divider(thickness: 2),
              SizedBox(height: SizeConfig.getHeight(2)),
              Center(
                child: NormalText(text: "Transaction ID: ${_transactionResource.transaction.identifier}", size: SizeConfig.getWidth(4), color: Colors.black54),
              )
            ],
          ),
          bottomNavigationBar: state.isButtonVisible ? BlocProvider<PayButtonBloc>(
            create: (BuildContext context) => PayButtonBloc(
              transactionRepository: _transactionRepository,
              transactionResource: _transactionResource
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: PayButton(transactionResource: _transactionResource),
            ),
          ) : null
        );
      }
    ); 
  }

  int _setTotal({@required TransactionResource transactionResource}) {
    if (transactionResource.refunds.length > 0) {
      return transactionResource.transaction.total - transactionResource.refunds.fold(0, (total, refund) => total + refund.total);
    }
    return transactionResource.transaction.total;
  }

  Widget _createRefundRow({@required TransactionResource transactionResource}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        NormalText(
          text: "Total Refund", 
          size: SizeConfig.getWidth(5), 
          color: Colors.red
        ),
        NormalText(
          text: "(${Currency.create(cents: transactionResource.refunds.fold(0, (total, refund) => total + refund.total))})", 
          size: SizeConfig.getWidth(5), 
          color: Colors.red
        ),
      ],
    );
  }

  Widget _createFooterRow(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        NormalText(
          text: title, 
          size: SizeConfig.getWidth(5), 
          color: Colors.black
        ),
        NormalText(
          text: Currency.create(cents: value), 
          size: SizeConfig.getWidth(5), 
          color: Colors.black
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