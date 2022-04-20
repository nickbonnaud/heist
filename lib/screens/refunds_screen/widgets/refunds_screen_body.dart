import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_loader.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';
import 'package:heist/global_widgets/refund_widget.dart';
import 'package:heist/screens/refunds_screen/bloc/refunds_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'filter_button/bloc/filter_button_bloc.dart';
import 'filter_button/filter_button.dart';

class RefundsScreenBody extends StatefulWidget {

  const RefundsScreenBody({Key? key})
    : super(key: key);
  
  @override
  State<RefundsScreenBody> createState() => _RefundsScreenBodyState();
}

class _RefundsScreenBodyState extends State<RefundsScreenBody> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200.h;
  late RefundsScreenBloc _refundsScreenBloc;

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
            body: "Oops! An error occurred fetching previous refunds!",
            buttonText: "Retry",
            onButtonPressed: () => BlocProvider.of<RefundsScreenBloc>(context).add(const FetchAllRefunds(reset: true)),
          );
        }

        return Stack(
          key: const Key("refundsListKey"),
          children: [
            _refundsBody(state: state),
            _filterButton(context: context, state: state)
          ],
        );
      }
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _refundsBody({required RefundsScreenState state}) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        DefaultAppBar(
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          isSliver: true,
          title: "Refunds",
        ),
        _buildList(state: state)
      ],
    );
  }
  
  Widget _buildList({required RefundsScreenState state}) {
    if (state is RefundsLoaded) {
      if (state.refunds.isEmpty) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          sliver: SliverFillRemaining(
            child: Center(
              child: Text(
                'No Refunds Found!',
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
            (BuildContext context, int index) => index >= state.refunds.length
              ? const BottomLoader()
              :  RefundWidget(
                  refundResource: state.refunds[index],
                  key: Key("refundKey-$index"),
                ),
            childCount: state.hasReachedEnd
              ? state.refunds.length
              : state.refunds.length +1,
            
          ),
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      sliver: const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        hasScrollBody: false,
      ),
    );
  }

  Widget _filterButton({required BuildContext context, required RefundsScreenState state}) {
    if (state is RefundsLoaded) {
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
      _refundsScreenBloc.add(FetchMoreRefunds());
    }
  }
}