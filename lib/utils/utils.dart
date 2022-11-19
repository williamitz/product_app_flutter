import 'dart:io';


class Utils {
  
  static String serverHost = Platform.isAndroid ? '192.168.18.183:3000' : 'localhost:3000';
  static String prefixHost = 'api';
  static String emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static String fullTextPattern = r'^[a-zA-Z\s]{0,100}$';
  static String phonePattern = r'^[\d\s+]{6,12}$';

}