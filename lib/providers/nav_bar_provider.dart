import 'package:flutter/material.dart';

class NavBarProvider with ChangeNotifier {
  
  int _currentIndex = 0;

  int get currentIndex {
    return _currentIndex;
  }

  set currentIndex( int val ) {
    _currentIndex = val;

    notifyListeners();
  }

}