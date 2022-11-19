import 'package:flutter/material.dart';
import 'package:product_app/providers/auth_provider.dart';
import 'package:product_app/providers/product_provider.dart';
import 'package:product_app/services/ui_service.dart';
import 'package:provider/provider.dart';

import 'package:product_app/providers/nav_bar_provider.dart';
import 'package:product_app/screens/screens.dart';

void main() => runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavBarProvider() ),
        ChangeNotifierProvider(create: (context) => ProductProvider() ),
        ChangeNotifierProvider(create: (context) => AuthProvider() ),
      ],
      child: MyApp(),
    )
  
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Material App',
      debugShowCheckedModeBanner: false,

      initialRoute: 'splash',
      scaffoldMessengerKey: UiService.messengerKey,
      routes: {
        '': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'product': (_) => const ProductScreen(),
        'singin': (_) => const SinginScreen(),
        'splash': (_) => const SplashScreen()
      },

      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        primaryColor: Colors.indigo
      ),
    );
  }
}