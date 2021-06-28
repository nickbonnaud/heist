import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:provider/provider.dart';
import 'package:heist/themes/global_colors.dart';

import 'page_offset_notifier.dart';


class PageIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.getHeight(3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  key: Key("loginIndicatorKey"),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() == 0 
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onSecondarySubdued
                  ),
                  height: 6,
                  width: 6,
                ),
                SizedBox(width: 8),
                Container(
                  key: Key("registerIndicatorKey"),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() != 0 
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onSecondarySubdued
                  ),
                  height: 6,
                  width: 6,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}