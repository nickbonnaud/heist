import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../page_offset_notifier.dart';
import 'widgets/login/login.dart';
import 'widgets/register/register.dart';

class Forms extends StatelessWidget {
  final PageController _pageController;

  const Forms({required PageController pageController, Key? key})
    : _pageController = pageController,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        if (notifier.page.round() == 0) {
          return Login(pageController: _pageController);
        } else {
          return Register(pageController: _pageController);
        }
      }
    );
  }
}