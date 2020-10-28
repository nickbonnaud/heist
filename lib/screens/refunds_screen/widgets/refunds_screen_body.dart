import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';
import 'package:heist/global_widgets/refund_widget.dart';
import 'package:heist/resources/helpers/bottom_loader.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/refunds_screen/bloc/refunds_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'filter_button/bloc/filter_button_bloc.dart';
import 'filter_button/filter_button.dart';

class RefundsScreenBody extends StatefulWidget {

  @override
  State<RefundsScreenBody> createState() => _RefundsScreenBodyState();
}

class _RefundsScreenBodyState extends State<RefundsScreenBody> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200.0;
  RefundsScreenBloc _refundsScreenBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refundsScreenBloc = BlocProvider.of<RefundsScreenBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundsScreenBloc, RefundsScreenState>(
      builder: (context, state) {
        if (state is FetchFailure) {
          return ErrorScreen(
            body: "Oops! An error occurred fetching previous refunds!\n\n Please try again.",
            buttonText: "Retry",
            onButtonPressed: () => BlocProvider.of<RefundsScreenBloc>(context).add(FetchAllRefunds(reset: true)),
          );
        }

        return Stack(
          children: <Widget>[
            _buildRefundsBody(state: state),
            _buildFilterButton(context: context, state: state)
          ],
        );
      }
    );
  }

  Widget _buildRefundsBody({@required RefundsScreenState state}) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        DefaultAppBar(
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          isSliver: true,
          title: "Refunds",
        ),
        _buildList(state: state)
      ],
    );
  }
  
  Widget _buildList({@required RefundsScreenState state}) {
    if (state is RefundsLoaded) {
      if (state.refunds.isEmpty) {
        return SliverPadding(
          padding: EdgeInsets.only(left: 8, right: 8),
          sliver: SliverFillRemaining(
            child: Center(
              child: BoldText1(
                text: 'No Refunds Found!', 
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
            (BuildContext context, int index) => index >= state.refunds.length
              ? BottomLoader()
              :  RefundWidget(refundResource: state.refunds[index]),
            childCount: state.hasReachedEnd
              ? state.refunds.length
              : state.refunds.length +1,
            
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

  Widget _buildFilterButton({@required BuildContext context, @required RefundsScreenState state}) {
    if (state is RefundsLoaded) {
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
    return Container();
  }
  
  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      _refundsScreenBloc.add(FetchMoreRefunds());
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}