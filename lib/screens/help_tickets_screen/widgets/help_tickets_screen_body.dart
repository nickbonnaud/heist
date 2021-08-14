import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'widgets/filter_button/bloc/filter_button_bloc.dart';
import 'widgets/filter_button/filter_button.dart';
import 'widgets/help_ticket_widget.dart';


class HelpTicketsScreenBody extends StatefulWidget {
  
  @override
  State<HelpTicketsScreenBody> createState() => _HelpTicketsScreenBodyState();
}

class _HelpTicketsScreenBodyState extends State<HelpTicketsScreenBody> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200.0;
  
  late HelpTicketsScreenBloc _helpTicketsScreenBloc;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _helpTicketsScreenBloc = BlocProvider.of<HelpTicketsScreenBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpTicketsScreenBloc, HelpTicketsScreenState>(
      builder: (context, state) {
        if (state is FetchFailure) {
          return ErrorScreen(
            body: "Oh no! An error occurred fetching your help tickets.\n\n Please try again.",
            buttonText: "Retry",
            onButtonPressed: () => _helpTicketsScreenBloc.add(FetchAll(reset: true)),
          );
        }

        return Stack(
          key: Key('helpTicketsListKey'),
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
            padding: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(Icons.edit), 
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
          padding: EdgeInsets.only(left: 8, right: 8),
          sliver: SliverFillRemaining(
            child: Center(
              child: BoldText1(
                text: 'No Help Tickets found!',
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
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) => index >= state.helpTickets.length
            ? CircularProgressIndicator()
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
      padding: EdgeInsets.only(left: 8, right: 8),
      sliver: SliverFillRemaining(
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
        bottom: -SizeConfig.getHeight(5),
        right: -SizeConfig.getWidth(10 ),
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
    Navigator.of(context).pushNamed(Routes.helpTicketNew, arguments: _helpTicketsScreenBloc)
      .then((_) => BlocProvider.of<DefaultAppBarBloc>(context).add(Reset()));
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <=_scrollThreshold) {
      _helpTicketsScreenBloc.add(FetchMore());
    }
  }
}