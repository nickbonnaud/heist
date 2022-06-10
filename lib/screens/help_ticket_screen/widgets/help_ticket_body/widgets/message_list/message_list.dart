import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/message_list_bloc.dart';
import 'widgets/message_bubble.dart';
import '../widgets/message_bubble_text.dart';
import '../widgets/message_date_text.dart';

class MessageList extends StatelessWidget {
  final ScrollController _scrollController;

  const MessageList({required ScrollController scrollController, Key? key})
    : _scrollController = scrollController,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageListBloc, MessageListState>(
      builder: (context, state) {
        return ListView.builder(
          key: const Key("messageListKey"),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          itemCount: state.helpTicket.replies.length + 1,
          reverse: true,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == state.helpTicket.replies.length) {
              return _initialHelpMessage(context: context, state: state, index: index);
            }
            return MessageBubble(reply: state.helpTicket.replies[index], key: Key("messageBubbleKey-$index"));
          }
        );
      },
    );
  }

  Widget _initialHelpMessage({required BuildContext context, required MessageListState state, required int index}) {
    return Container(
      key: Key("messageBubbleKey-$index"),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      state.helpTicket.subject, 
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onCallToAction,
                        fontSize: 18.sp
                      ),
                    ),
                    MessageBubbleText(message: state.helpTicket.message)
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                width: 200.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.callToAction,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                margin: EdgeInsets.only(right: 10.w),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: MessageDateText(text: DateFormatter.toStringDateTime(date: state.helpTicket.updatedAt)),
                margin: EdgeInsets.only(left: 5.w, top: 5.h, bottom: 5.h),
              )
            ],
          ),
          if (state.helpTicket.read)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                MessageDateText(text: "Read", isDate: false)
              ],
            )
        ],
      ),
    );
  }
}