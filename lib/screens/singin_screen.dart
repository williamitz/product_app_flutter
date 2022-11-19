import 'package:flutter/material.dart';
import 'package:product_app/providers/auth_provider.dart';
import 'package:product_app/providers/product_provider.dart';
import 'package:product_app/ui/input_decorations.dart';
import 'package:product_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class SinginScreen extends StatelessWidget {

  const SinginScreen({super.key});

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

                      Text('Singin', style: Theme.of(context).textTheme.headline4,),

                      const SizedBox( height: 10 ),
                      

                      ChangeNotifierProvider(
                        create: (context) => AuthProvider(),
                        child: const _SinginForm(),
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
                onPressed: () => Navigator.pushReplacementNamed(context, ''),
                child: const Text(
                  '¿Ya tienes una cuenta?', 
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


class _SinginForm extends StatelessWidget {
  const _SinginForm({super.key});

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
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              initialValue: provider.fullName,
              decoration: InputDecorations.loginDecoration( 
                icon: Icons.label_important_outline_rounded,
                labelText: 'Nombres y apellidos',
                hintText: 'Fulanito De Tal'
              ),
              onChanged: (value) => provider.fullName = value,
              validator: (value) {

                if( value == null ){
                  return 'Requerido';
                } else if( value.length < 3 ) {
                  return 'Mínimo 06 letras';
                }
                
                RegExp regExp = RegExp( Utils.fullTextPattern );

                return regExp.hasMatch( value ) ? null : 'Email inválido';

              },

            ),

            const SizedBox( height: 20 ),

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.number,
              initialValue: provider.phone,
              decoration: InputDecorations.loginDecoration( 
                icon: Icons.phone_in_talk_outlined,
                labelText: 'Teléfono',
                hintText: '+51 000 000 000'
              ),
              onChanged: (value) => provider.phone = value,
              validator: (value) {

                if( value == null ){
                  return 'Requerido';
                }
                
                RegExp regExp = RegExp( Utils.phonePattern );

                return regExp.hasMatch( value ) ? null : 'Teléfono inválido';

              },

            ),

            const SizedBox( height: 20 ),

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              initialValue: provider.email,
              decoration: InputDecorations.loginDecoration( 
                icon: Icons.alternate_email_outlined,
                labelText: 'Correo electrónico',
                hintText: 'example@domain.con'
              ),
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

                final success = await provider.onSingin();

                if( !success ) return;


               // ignore: use_build_context_synchronously
               ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

                await productProvider.onGetProducts();
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

