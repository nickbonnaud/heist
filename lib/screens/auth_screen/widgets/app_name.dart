import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/auth_screen/auth_screen.dart';
import 'package:heist/screens/auth_screen/widgets/page_offset_notifier.dart';
import 'package:provider/provider.dart';
import 'package:heist/themes/global_colors.dart'; 

class AppName extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: topMargin(context: context)),
          Consumer2<PageOffsetNotifier, AnimationController>(
            builder: (context, notifier, animation, child) {
              return Transform.translate(
                offset: Offset(0 - 0.5 * notifier.offset, 0),
                child: Opacity(
                  opacity: 1 - .95 * animation.value,
                  child: child,
                ),
              );
            },
            child: RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                width: mainSquareSize(context: context),
                child: FittedBox(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  child: PlatformText(
                    Constants.appName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Theme.of(context).colorScheme.textOnDark
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}