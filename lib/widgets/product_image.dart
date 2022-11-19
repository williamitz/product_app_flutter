import 'package:flutter/material.dart';
import 'dart:io';

class ProductImage extends StatelessWidget {

  final String urlImg;

  const ProductImage({super.key, required this.urlImg});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only( left: 10, right: 10, top: 10 ),
      width: double.infinity,
      height: 400,

      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only( topLeft: Radius.circular( 45 ), topRight: Radius.circular( 45) ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset( 0,5 )
          )
        ]
      ),

      child: Opacity(
        opacity: 0.9,
        child: ClipRRect(
          borderRadius:  const BorderRadius.only( topLeft: Radius.circular( 45 ), topRight: Radius.circular( 45) ),
          child: buildImg( urlImg ),
        ),
      ),

    );
  }

  Widget buildImg( String urlImg ) {
    
    print('buildImg ============ $urlImg');

    if( urlImg.isEmpty ) {
      print('buildImg ============ AssetImage');
      return const Image( 
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );

    } else if( urlImg.contains('http') ) {
      print('buildImg ============ FadeInImage');
      return FadeInImage(
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage( urlImg ),
        fit: BoxFit.cover,
      );
      
    } 

    print('buildImg ============ Image.file');

    return  Image.file(
        File(
          urlImg
        ),
        fit: BoxFit.cover,
      );

  }

}