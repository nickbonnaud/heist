import 'package:flutter/material.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier({required PageController pageController}) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page ?? _page;
      notifyListeners();
    });
  }

  double get offset => _offset;
  double get page => _page;
}