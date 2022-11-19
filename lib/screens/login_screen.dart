import 'package:flutter/material.dart';
import 'package:product_app/providers/auth_provider.dart';
import 'package:product_app/providers/product_provider.dart';
import 'package:product_app/services/ui_service.dart';
import 'package:product_app/ui/input_decorations.dart';
import 'package:product_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AuthBackground(

        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox( height: 250 ),

              CardContainer(

                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [

                      const SizedBox( height: 10 ),

                      Text('Login', style: Theme.of(context).textTheme.headline4,),

                      const SizedBox( height: 10 ),
                      

                      ChangeNotifierProvider(
                        create: (context) => AuthProvider(),
                        child: const _LoginForm(),
                      )
                      

                    ],
                  ),

                ),

              ),

              const SizedBox( height: 50 ),

              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all( Colors.indigo.withOpacity(0.1) ),
                  shape: MaterialStateProperty.all( const StadiumBorder() ),
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, 'singin'),
                child: const Text(
                  'Crea una nueva cuenta', 
                  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black )
                ),
              ),

              const SizedBox( height: 50 ),

            ],
          ),
        ),

      ),
    );
  }
}


class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {

    AuthProvider provider = Provider.of<AuthProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 20 ),
      child: Form(
        key: provider.formKeySingin,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(

          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.loginDecoration( 
                icon: Icons.alternate_email_outlined,
                labelText: 'Correo electrónico',
                hintText: 'example@domain.con'
              ),
              initialValue: provider.email,
              onChanged: (value) => provider.email = value,
              validator: (value) {
                
                RegExp regExp = RegExp( Utils.emailPattern );

                return regExp.hasMatch( value! ) ? null : 'Email inválido';

              },

            ),

            const SizedBox( height: 20 ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              initialValue: provider.password,
              decoration: InputDecorations.loginDecoration( 
                icon: Icons.lock_outline,
                labelText: 'Contraseña',
                hintText: '***'
              ),
              onChanged: (value) => provider.password = value,
              validator: (value) {

                if( value != null && value.length > 3 ) return null;

                return 'requerido';

              },

            ),

            const SizedBox( height: 20 ),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              disabledColor: Colors.grey,
              color: Colors.deepPurple,
              onPressed: !provider.validate ? null : () async {

                // ocultar botón
                FocusScope.of(context).unfocus();

                final success = await provider.onLogin();

                if( !success ) {
                  
                  UiService.showSnackbar('Usuario o contraseña inválidos');
                  return;
                }

                ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

                await productProvider.onGetProducts();

                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, 'home');
              },
              child: Container(
                padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 10 ),
                child: Text(
                  provider.loading ? 'validando...' : 'Ingresar', 
                  style: const TextStyle( color: Colors.white )
                ),

              ),
            )

          ],

        ),

      ),

    );
  }
}

