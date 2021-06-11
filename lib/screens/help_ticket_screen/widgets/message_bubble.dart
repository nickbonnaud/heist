import 'package:flutter/material.dart';
import 'package:heist/models/help_ticket/reply.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

class MessageBubble extends StatelessWidget {
  final Reply _reply;

  MessageBubble({required Reply reply})
    : _reply = reply;

  @override
  Widget build(BuildContext context) {
    if (_reply.fromCustomer) {
      return Container(
        margin: EdgeInsets.only(bottom: SizeConfig.getHeight(5)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text3(
                    text: _reply.message, 
                    context: context,
                    color: Theme.of(context).colorScheme.onCallToAction,
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: SizeConfig.getWidth(53),
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
                  width: SizeConfig.getWidth(55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text4(
                          text: 'Sent on ${_reply.createdAt}', 
                          context: context,
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                        ),
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      ),

                      if (_reply.read)
                        Container(
                          padding: EdgeInsets.only(right: 15.0, top: 5.0, bottom: 5.0),
                          child: Text4(
                            text: "Read",
                            context: context,
                            color: Theme.of(context).colorScheme.onPrimaryDisabled,
                          ),
                        )
                    ],
                  )
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: SizeConfig.getHeight(5)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Text3(
                    text: _reply.message,
                    context: context,
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: SizeConfig.getWidth(53),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.callToActionDisabled,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: SizeConfig.getWidth(55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                      child: Text4(
                        text: 'Sent on ${_reply.createdAt}',
                        context: context,
                        color: Theme.of(context).colorScheme.onPrimarySubdued,
                      ),
                      padding: EdgeInsets.only(left: 12.0, top: 5.0, bottom: 5.0),
                    ),

                    if (_reply.read)
                      Container(
                        child: Text4(
                          text: 'Read', 
                          context: context,
                          color: Theme.of(context).colorScheme.onPrimaryDisabled,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ) 
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }
}