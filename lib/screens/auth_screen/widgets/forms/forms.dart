import 'package:flutter/material.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:provider/provider.dart';

import '../page_offset_notifier.dart';
import 'widgets/login/login.dart';
import 'widgets/register/register.dart';

class Forms extends StatelessWidget {
  final CustomerRepository _customerRepository = CustomerRepository();
  final PageController _pageController;

  Forms({@required PageController pageController})
    : assert(pageController != null),
      _pageController = pageController;

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        if (notifier.page.round() == 0) {
          return Login(customerRepository: _customerRepository, pageController: _pageController);
        } else {
          return Register(customerRepository: _customerRepository, pageController: _pageController);
        }
      }
    );
  }
}