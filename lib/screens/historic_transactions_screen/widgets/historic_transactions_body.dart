import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_loader.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';
import 'package:heist/global_widgets/transaction_widget.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'filter_button/bloc/filter_button_bloc.dart';
import 'filter_button/filter_button.dart';

class HistoricTransactionsBody extends StatefulWidget {

  @override
  State<HistoricTransactionsBody> createState() => _HistoricTransactionsBodyState();
}

class _HistoricTransactionsBodyState extends State<HistoricTransactionsBody> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200.h;
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
          key: Key("transactionsListKey"),
          children: [
            _transactionsBody(state: state),
            _filterButton(context: context, state: state)
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

  Widget _transactionsBody({required HistoricTransactionsState state}) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        DefaultAppBar(
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
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          sliver: SliverFillRemaining(
            child: Center(
              child: Text(
                'No Transactions Found!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,
                ),
              )
            ),
            hasScrollBody: false,
          ),
        );
      }
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => index >= state.transactions.length
              ? BottomLoader()
              : TransactionWidget(
                  transactionResource: state.transactions[index],
                  key: Key("transactionKey-$index"),
                ),
            childCount: state.hasReachedEnd
              ? state.transactions.length
              : state.transactions.length + 1
          ),
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      sliver: SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        hasScrollBody: false,
      ),
    );
  }

  Widget _filterButton({required BuildContext context, required HistoricTransactionsState state}) {
    if (state is TransactionsLoaded) {
      return Positioned(
        bottom: -40.h,
        right: -40.w,
        child: BlocProvider<FilterButtonBloc>(
          create: (_) => FilterButtonBloc(),
          child: FilterButton(
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