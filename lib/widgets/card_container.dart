import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.symmetric( horizontal: 30 ),

      width: double.infinity,
      // height: 300,

      decoration: _cardDecoration(),
      child: child,

    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(

      color: Colors.white,
      borderRadius: BorderRadius.circular( 25 ),
      boxShadow:  const [

        BoxShadow(
          color: Colors.black12,
          blurRadius: 15,
          offset: Offset( 0, 5 )
        )

      ]

    );
  }
}