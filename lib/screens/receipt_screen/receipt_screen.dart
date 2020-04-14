import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/widgets/purchased_item_widget.dart';

class ReceiptScreen extends StatelessWidget {
  final TransactionResource _transactionResource;

  const ReceiptScreen({@required TransactionResource transactionResource})
    : assert(transactionResource != null),
      _transactionResource = transactionResource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(height:SizeConfig.getHeight(1)),
                _createFooterRow("Tip", _transactionResource.transaction.tip),
                SizedBox(height:SizeConfig.getHeight(3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BoldText(text: "Total", size: SizeConfig.getWidth(7), color: Colors.black),
                    BoldText(text: Currency.create(cents: _transactionResource.transaction.total), size: SizeConfig.getWidth(7), color: Colors.black),
                  ],
                )
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
          )
        ],
      ),
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
}