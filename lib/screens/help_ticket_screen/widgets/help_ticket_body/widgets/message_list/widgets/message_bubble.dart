import 'package:flutter/material.dart';
import 'package:heist/models/help_ticket/reply.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/message_bubble_text.dart';
import '../../widgets/message_date_text.dart';


class MessageBubble extends StatelessWidget {
  final Reply _reply;

  const MessageBubble({required Reply reply, required Key key})
    : _reply = reply,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_reply.fromCustomer) {
      return _customerReply(context: context);
    } else {
      return _adminReply(context: context);
    }
  }

  Widget _customerReply({required BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: MessageBubbleText(message: _reply.message),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                width: .53.sw,
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
              SizedBox(
                width: .55.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: MessageDateText(text: 'Sent ${DateFormatter.toStringDateTime(date: _reply.createdAt)}'),
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                    ),

                    if (_reply.read)
                      Container(
                        padding: EdgeInsets.only(right: 15.w, top: 5.h, bottom: 5.h),
                        child: const MessageDateText(text: "Read", isDate: false) 
                      )
                  ],
                )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _adminReply({required BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                child: MessageBubbleText(message: _reply.message, fromAdmin: true),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                width: .53.sw,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.callToActionDisabled,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                margin: EdgeInsets.only(left: 10.w),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: .55.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: MessageDateText(text: 'Sent ${DateFormatter.toStringDateTime(date: _reply.createdAt)}'),
                      padding: EdgeInsets.only(left: 12.w, top: 5.h, bottom: 5.h),
                    ),

                    if (_reply.read)
                      const MessageDateText(text: "Read", isDate: false)
                  ],
                ),
              )
            ],
          ) 
        ],
      ),
    );
  }
}