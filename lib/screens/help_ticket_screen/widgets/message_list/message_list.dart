import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/help_ticket_screen/widgets/message_list/bloc/message_list_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import '../message_bubble.dart';

class MessageList extends StatelessWidget {
  final ScrollController _scrollController;

  MessageList({@required ScrollController scrollController})
    : assert(scrollController != null),
      _scrollController = scrollController;
  
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: BlocBuilder<MessageListBloc, MessageListState>(
        builder: (context, state) {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: state.helpTicket.replies.length + 1,
            reverse: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == state.helpTicket.replies.length) {
                return _initialHelpMessage(context: context, state: state);
              }
              return MessageBubble(reply: state.helpTicket.replies[index]);
            }
          );
        },
      )
    );
  }

  Widget _initialHelpMessage({@required BuildContext context, @required MessageListState state}) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Column(
                  children: [
                    Text2(
                      text: state.helpTicket.subject, 
                      context: context,
                      color: Theme.of(context).colorScheme.onCallToAction,
                    ),
                    Text3(
                      text: state.helpTicket.message, 
                      context: context,
                      color: Theme.of(context).colorScheme.onCallToAction,
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.callToAction,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                margin: EdgeInsets.only(right: 10.0),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Text4(
                  text: state.helpTicket.updatedAt, 
                  context: context,
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            ],
          ),
          if (state.helpTicket.read)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text4(
                    text: "Read",
                    context: context,
                    color: Theme.of(context).colorScheme.onPrimarySubdued,
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}