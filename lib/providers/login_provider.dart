import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {

  GlobalKey<FormState> formKey =  GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  bool _loading = false;

  bool valid() {

    if( loading ) return false;

    return formKey.currentState?.validate() ?? false;
  }

  set email( String email ) {
    _email = email;
    notifyListeners();
  }

  set psw( String psw ) {
    _password = psw;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading( bool loading ) {
    _loading = loading;

    notifyListeners();
  }
  
}