import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/transaction_widget.dart';
import 'package:heist/resources/helpers/bottom_loader.dart';
import 'package:heist/resources/helpers/loading_widget.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'filter_button.dart';

class HistoricTransactionsBody extends StatefulWidget {

  @override
  State<HistoricTransactionsBody> createState() => _HistoricTransactionsBodyState();
}

class _HistoricTransactionsBodyState extends State<HistoricTransactionsBody> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200.0;
  HistoricTransactionsBloc _historicTransactionsBloc;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _historicTransactionsBloc = BlocProvider.of<HistoricTransactionsBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoricTransactionsBloc, HistoricTransactionsState>(
      builder: (context, state) {
        if (state is Uninitialized || state is Loading) {
          return Center(
            child: LoadingWidget(),
          );
        }

        if (state is FetchFailure) {
          return Center(
            child: BoldText4(text: 'Failed to Fetch Posts', context: context, color: Colors.black),
          );
        }

        if (state is TransactionsLoaded) {
          if (state.transactions.isEmpty) {
            return Center(
              child: BoldText4(text: 'No Transactions', context: context, color: Colors.black),
            );
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              DefaultAppBar(
                backgroundColor: Theme.of(context).colorScheme.scrollBackgroundLight,
                isSliver: true,
                trailingWidget: FilterButton(),
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 8, right: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => index >= state.transactions.length 
                      ? BottomLoader()
                      : TransactionWidget(transactionResource: state.transactions[index]),
                    childCount: state.hasReachedEnd
                      ? state.transactions.length
                      : state.transactions.length + 1,
                  )
                ),
              )
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      _historicTransactionsBloc.add(FetchMoreTransactions());
    }
  }
}