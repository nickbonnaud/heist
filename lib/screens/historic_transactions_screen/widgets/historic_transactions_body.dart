import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';
import 'package:heist/global_widgets/transaction_widget.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/global_widgets/bottom_loader.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'filter_button/bloc/filter_button_bloc.dart';
import 'filter_button/filter_button.dart';

class HistoricTransactionsBody extends StatefulWidget {
  final BusinessRepository _businessRepository;

  HistoricTransactionsBody({required BusinessRepository businessRepository})
    : _businessRepository = businessRepository;

  @override
  State<HistoricTransactionsBody> createState() => _HistoricTransactionsBodyState();
}

class _HistoricTransactionsBodyState extends State<HistoricTransactionsBody> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200.0;
  late HistoricTransactionsBloc _historicTransactionsBloc;
  
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
        if (state is FetchFailure) {
          return ErrorScreen(
            body: "Oops! An error occurred fetching previous transactions!\n\n Please try again.",
            buttonText: "Retry",
            onButtonPressed: () => BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchHistoricTransactions(reset: true)),
          );
        }

        return Stack(
          children: <Widget>[
            _buildTransactionsBody(state: state),
            _buildFilterButton(context: context, state: state)
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildTransactionsBody({required HistoricTransactionsState state}) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        DefaultAppBar(
          context: context,
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          isSliver: true,
          title: "Transactions",
        ),
        _buildList(state: state)
      ],
    );
  }

  Widget _buildList({required HistoricTransactionsState state}) {
    if (state is TransactionsLoaded) {
      if (state.transactions.isEmpty) {
        return SliverPadding(
          padding: EdgeInsets.only(left: 8, right: 8),
          sliver: SliverFillRemaining(
            child: Center(
              child: BoldText1(
                text: 'No Transactions Found!', 
                context: context, 
              ),
            ),
            hasScrollBody: false,
          ),
        );
      }
      return SliverPadding(
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
      );
    }
    return SliverPadding(
      padding: EdgeInsets.only(left: 8, right: 8),
      sliver: SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        hasScrollBody: false,
      ),
    );
  }

  Widget _buildFilterButton({required BuildContext context, required HistoricTransactionsState state}) {
    if (state is TransactionsLoaded) {
      return Positioned(
        bottom: -SizeConfig.getHeight(5),
        right: -SizeConfig.getWidth(10 ),
        child: BlocProvider<FilterButtonBloc>(
          create: (_) => FilterButtonBloc(),
          child: FilterButton(
            businessRepository: widget._businessRepository,
            startColor: Theme.of(context).colorScheme.callToAction,
            endColor: Theme.of(context).colorScheme.callToAction,
          ),
        )
      );
    }
    return Container();
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      _historicTransactionsBloc.add(FetchMoreTransactions());
    }
  }
}