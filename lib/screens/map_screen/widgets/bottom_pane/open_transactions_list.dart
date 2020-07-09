import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/map_screen/widgets/bottom_pane/show_transaction_button.dart';
import 'package:heist/themes/global_colors.dart';


class OpenTransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTransactionsBloc, OpenTransactionsState>(
      builder: (context, state) {
        final currentState = state;
        if (currentState is OpenTransactionsLoaded && currentState.transactions.length > 0) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.getWidth(15)),
                child: Divider(thickness: 2),
              ),
              SizedBox(height: SizeConfig.getHeight(1)),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Icon(
                      Icons.receipt,
                      size: SizeConfig.getWidth(10)
                    ),
                  ),
                  SizedBox(width: SizeConfig.getWidth(1)),
                  BoldText4(
                    text: "Open Transactions:",
                    context: context, 
                    color: Theme.of(context).colorScheme.textOnLightSubdued
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.getHeight(1)),
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 16, right: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (TransactionResource transaction in currentState.transactions) _buildIcon(transaction: transaction)
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      }
    );
  }

  Widget _buildIcon({@required TransactionResource transaction}) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: ShowTransactionButton(transaction: transaction)
    );
  }
}