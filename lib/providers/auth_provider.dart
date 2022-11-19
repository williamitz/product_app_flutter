import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:product_app/models/auth_model.dart';
import 'package:product_app/utils/utils.dart';


class AuthProvider with ChangeNotifier {
  

  final String _uri = Utils.serverHost;

  final GlobalKey<FormState> formKeySingin = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  String _stFullName = '';
  String _stEmail = '';
  String _stId = '';
  
  String _fullName = '';
  String _email    = '';
  String _password = '';
  String _phone    = '';

  bool _loading = false;
  bool _validFrm = false;

  String get fullName => _fullName; 
  String get email => _email; 
  String get password => _password; 
  String get phone => _phone; 
  String get stFullName => _stFullName; 
  String get stEmail => _stEmail; 
  String get stId => _stId; 

  bool get loading => _loading; 
  bool get validate{

    if( loading ) return false;

    final currentState = formKeySingin.currentState?.validate() ?? false; 
    if( currentState != _validFrm ) {
      notifyListeners();
      _validFrm = currentState;
    }

    return _validFrm;
    
  }
  
  set fullName( String val ) {
    _fullName = val;
    validate;
  }
  set email( String val ) {
    _email = val;
    validate;
  } 
  set password( String val ) {
    _password = val; 
    validate;
  }
  set phone( String val ) {
    _phone = val;
    validate;
  }
  set loading( bool val ) {
    _loading = val;
  }

  void _onReset() {
    fullName = '';
    email = '';
    password = '';
    phone = '';
    _loading = false;
    notifyListeners();
  }

  Future<AuthResponse?> _executeHttp( [bool singin = false] ) async {

    try {

      Uri uriHttp = Uri.http( _uri, singin ? '/api/auth/register' : '/api/auth/login' );

      Map<String, String> body = {
        "email": _email,
        "password": _password,
      };

      if( singin ) {
        body = {
          "email": _email,
          "password": _password,
          "fullName": _fullName,
          "phone": _phone,
        };
      }

      final response = await http.post( uriHttp, body: body );

      if (response.statusCode == 201) {

          final jsonRes = json.decode(response.body) as Map<String, dynamic>;

          // return AuthResponse.fromMap(jsonRes);
          return AuthResponse(
            email: jsonRes['email'],
            fullName: jsonRes['fullName'],
            id: jsonRes['id'],
            token: jsonRes['token'],
            phone: jsonRes['phone']
          );

      } else {
        return null;
      }
      
    } catch (e) {
      print('catch $e');
      return null;
      // throw Exception('Failed execute http $e');
      
    }

  }

  Future<bool> onSingin() async {
    loading = true;
    notifyListeners();

    final response = await _executeHttp( true );

    if( response == null ) {
      loading = false;
      notifyListeners();
      return false;
    }

    _stFullName = response.fullName;
    _stEmail = response.email;
    await _storage.write( key: 'token', value: response.token );
    await _storage.write( key: 'fullname', value: response.fullName );
    await _storage.write( key: 'email', value: response.email );
    await _storage.write( key: 'id', value: response.id );

    // loading = false;
    // notifyListeners();
    _onReset();
    return true;

  }

  Future<bool> onLogin() async {
    loading = true;
    notifyListeners();

    final response = await _executeHttp();

    if( response == null ) {
      loading = false;
      notifyListeners();
      return false;
    }

    _stFullName = response.fullName;
    _stEmail = response.email;

    await _storage.write( key: 'token', value: response.token );
    await _storage.write( key: 'fullname', value: response.fullName );
    await _storage.write( key: 'email', value: response.email );
    await _storage.write( key: 'id', value: response.id );

    // loading = false;
    // notifyListeners();
    _onReset();
    return true;

  }

  Future<void> onLogout() async  {

    _stFullName = '';
    _stEmail = '';
    _stId = '';

    await _storage.delete( key: 'token' );
    await _storage.delete( key: 'fullname' );
    await _storage.delete( key: 'email' );
    await _storage.delete( key: 'id' );

    notifyListeners();
  }

  Future<String> onReadToken() async {

    _stFullName = await _storage.read(key: 'fullname') ?? '';
    _stEmail = await _storage.read(key: 'email') ?? '';
    _stId = await _storage.read(key: 'id') ?? '';


    notifyListeners();
    return await _storage.read(key: 'token') ?? '';

  }

}