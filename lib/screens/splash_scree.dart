import 'package:flutter/material.dart';
import 'package:product_app/providers/auth_provider.dart';
import 'package:product_app/screens/screens.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {

  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final AuthProvider _provider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: _provider.onReadToken(),
        builder: (context, snapshot) {
          
          if( !snapshot.hasData ) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [

                  CircularProgressIndicator(),
                  SizedBox( height: 20 ),
                  Text('Hola Mundo'),

                ],
              ),
            );
          }

          Future.microtask(() {
            final token = snapshot.data ?? '';

            print('token ==== $token');

            if( token == null || token == '' ) {
              return Navigator.pushReplacement( context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginScreen(),
                transitionDuration: const Duration( seconds: 0 )
              ));
             } // else {
              // Navigator.of(context).pushReplacementNamed('home');

              return Navigator.pushReplacement( context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionDuration: const Duration( seconds: 0 )
              ));
            // }
              // Navigator.of(context).pushReplacementNamed('home');

          });

          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [

                  CircularProgressIndicator(),
                  SizedBox( height: 20 ),
                  Text('Hola Mundo'),

                ],
              ),
            );
      

        },
      )
   );
  }
}