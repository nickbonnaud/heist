import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/transaction_widget.dart';
import 'package:heist/resources/helpers/bottom_loader.dart';
import 'package:heist/resources/helpers/loading_widget.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';

class HistoricTransactionsList extends StatefulWidget {

  @override
  State<HistoricTransactionsList> createState() => _HistoricTransactionsListState();
}

class _HistoricTransactionsListState extends State<HistoricTransactionsList> {
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
            child: BoldText(text: 'Failed to Fetch Posts', size: 18.0, color: Colors.black),
          );
        }

        if (state is TransactionsLoaded) {
          if (state.transactions.isEmpty) {
            return Center(
              child: BoldText(text: 'No Transactions', size: 18.0, color: Colors.black),
            );
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.transactions.length
                ? BottomLoader()
                : TransactionWidget(transactionResource: state.transactions[index]);
            },
            itemCount: state.hasReachedEnd
              ? state.transactions.length
              : state.transactions.length + 1,
            controller: _scrollController,
          );
        }
      }
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
      _historicTransactionsBloc.add(FetchHistoricTransactions());
    }
  }
}