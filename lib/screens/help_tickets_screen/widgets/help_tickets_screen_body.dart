import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/global_widgets/bottom_loader.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'widgets/filter_button/bloc/filter_button_bloc.dart';
import 'widgets/filter_button/filter_button.dart';
import 'widgets/help_ticket_widget.dart';
import 'widgets/new_help_ticket_screen/new_help_ticket_screen.dart';


class HelpTicketsScreenBody extends StatefulWidget {
  
  const HelpTicketsScreenBody({Key? key})
    : super(key: key);
  
  @override
  State<HelpTicketsScreenBody> createState() => _HelpTicketsScreenBodyState();
}

class _HelpTicketsScreenBodyState extends State<HelpTicketsScreenBody> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200.h;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      builder: (context, state) {
        if (state is FetchFailure) {
          return ErrorScreen(
            body: "Oh no! An error occurred fetching your help tickets.",
            buttonText: "Retry",
            onButtonPressed: () => BlocProvider.of<HelpTicketsScreenBloc>(context).add(const FetchAll(reset: true)),
          );
        }

        return Stack(
          key: const Key('helpTicketsListKey'),
          children: [
            _helpTicketsBody(state: state),
            _filterButton(state: state)
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

  Widget _helpTicketsBody({required HelpTicketsScreenState state}) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        DefaultAppBar(
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          isSliver: true,
          title: "Help",
          trailingWidget: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              icon: const Icon(Icons.edit), 
              onPressed: () => _showCreateHelpTicketForm(),
              color: Theme.of(context).colorScheme.callToAction
            ),
          ),
        ),
        _buildHelpTicketList(state: state)
      ],
    );
  }

  Widget _buildHelpTicketList({required HelpTicketsScreenState state}) {
    if (state is Loaded) {
      if (state.helpTickets.isEmpty) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          sliver: SliverFillRemaining(
            child: Center(
              child: Text(
                'No Help Tickets found!',
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
            (BuildContext context, int index) => index >= state.helpTickets.length
              ? const BottomLoader()
              : HelpTicketWidget(
                  helpTicket: state.helpTickets[index],
                  key: Key('helpTicketKey-$index'),
                ),
            childCount: state.hasReachedEnd
              ? state.helpTickets.length
              : state.helpTickets.length + 1
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

  Widget _filterButton({required HelpTicketsScreenState state}) {
    if (state is Loaded) {
      return Positioned(
        bottom: -40.h,
        right: -40.w,
        child: BlocProvider<FilterButtonBloc>(
          create: (_) => FilterButtonBloc(),
          child: FilterButton(
            startColor: Theme.of(context).colorScheme.callToAction,
            endColor: Theme.of(context).colorScheme.callToAction
          ),
        )
      );
    }
    return Container();
  }

  void _showCreateHelpTicketForm() {
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());

    HelpTicketsScreenBloc helpTicketsScreenBloc = BlocProvider.of<HelpTicketsScreenBloc>(context);
    HelpRepository helpRepository = RepositoryProvider.of<HelpRepository>(context);

    Navigator.of(context).push(MaterialPageRoute<NewHelpTicketScreen>(
      fullscreenDialog: true,
      builder: (_) => BlocProvider.value(
        value: helpTicketsScreenBloc,
        child: RepositoryProvider.value(
          value: helpRepository,
          child: const NewHelpTicketScreen(),
        ),
      )
    )).then((_) => BlocProvider.of<DefaultAppBarBloc>(context).add(Reset()));
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <=_scrollThreshold) {
      BlocProvider.of<HelpTicketsScreenBloc>(context).add(FetchMore());
    }
  }
}