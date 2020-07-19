import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/loading_widget.dart';
import 'package:heist/resources/helpers/text_styles.dart';

class LoadingLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: BoldText3(text: 'Fetching Current Location', context: context),
          ),
          SizedBox(height: 15.0),
          LoadingWidget(),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }
}