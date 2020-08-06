import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/transaction_widget.dart';
import 'package:heist/resources/helpers/bottom_loader.dart';
import 'package:heist/resources/helpers/loading_widget.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'filter_button/bloc/filter_button_bloc.dart';
import 'filter_button/filter_button.dart';




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
        } else if (state is FetchFailure) {
          return Center(
            child: BoldText4(text: 'Failed to Fetch Posts', context: context, color: Colors.black),
          );
        } else if (state is TransactionsLoaded) {
          if (state.transactions.isEmpty) {
            return Center(
              child: BoldText4(text: 'No Transactions', context: context, color: Colors.black),
            );
          }
          return Stack(
            children: <Widget>[
              _buildTransactionsList(state: state),
              _buildFilterButton(context: context)
            ],
          );
        } else {
          return throw UnimplementedError();
        }
      },
    );
  }

  Widget _buildTransactionsList({@required TransactionsLoaded state}) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        DefaultAppBar(
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          isSliver: true,
          title: "Transactions",
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
                : state.transactions.length + 1
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFilterButton({@required BuildContext context}) {
    return Positioned(
      bottom: -SizeConfig.getHeight(5),
      right: -SizeConfig.getWidth(10 ),
      child: BlocProvider<FilterButtonBloc>(
        create: (_) => FilterButtonBloc(),
        child: FilterButton(
          startColor: Theme.of(context).colorScheme.callToAction,
          endColor: Theme.of(context).colorScheme.callToAction,
        ),
      )
    );
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      _historicTransactionsBloc.add(FetchMoreTransactions());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}