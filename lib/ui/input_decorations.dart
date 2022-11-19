import 'package:flutter/material.dart';

class InputDecorations {

  static InputDecoration loginDecoration( { 
    required IconData icon,
    required String labelText,
    String? hintText
  } ){

    return InputDecoration(

      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple
        )
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,
          width: 2
        )
      ),

      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle( color: Colors.grey ),
      prefixIcon: Icon( icon , color: Colors.deepPurple )

    );

  }
  
}

