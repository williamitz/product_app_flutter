import 'package:flutter/material.dart';
import 'package:product_app/models/product_model.dart';

class CardProduct extends StatelessWidget {

  final ProductModel product;

  const CardProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular( 30 ),
        boxShadow: const [

          BoxShadow(
            color: Colors.black26,
            offset: Offset( 1.5, 5 ),
            blurRadius: 10
          )

        ]
      ),

      child: Stack(

        children: [
          
           _ImageProduct( urlImg: product.urlImg ?? '' ),

          Column(

            children: [

              Row(
                children: [

                  if( !product.available ) const _AvailableTag(),

                  Expanded(child: Container()),
                  
                  _PriceTag( price: product.price ),
                ],
              ),

              Expanded(child: Container()),

              Row(
                children: [
                  _TitleTag( product:  product,),
                  Expanded(child: Container(  )),
                ],
              )

            ],

          )

        ],

      ),

    );
  }


}

class _TitleTag extends StatelessWidget {

  final ProductModel product;

  const _TitleTag({
    Key? key, required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 25, vertical: 15 ),
      decoration: BoxDecoration(

        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius .circular(30),
          topRight: Radius.circular(30)

        )

      ),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text( product.name , style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16 ),),
          Text('${ product.id }', 
            style: const TextStyle( 
              fontSize: 11, 
              color: Colors.white, 
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],

      ),
    );
  }
}

class _AvailableTag extends StatelessWidget {
  const _AvailableTag({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( vertical: 15, horizontal: 15 ),
      child: Text('No available'),
      decoration: const BoxDecoration(

        color: Colors.amber,
        borderRadius: BorderRadius.only( bottomRight: Radius.circular(30), topLeft: Radius.circular(30) )

      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  final double price;

  const _PriceTag({
    Key? key, required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( vertical: 15, horizontal: 15 ),
      child: Text(
        'S/ $price', 
        style: TextStyle( color: Colors.white )
      ),
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.only( bottomLeft: Radius.circular(30), topRight: Radius.circular(30) )

      ),
    );
  }
}

class _ImageProduct extends StatelessWidget {

  final String urlImg;

  const _ImageProduct({
    Key? key, required this.urlImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular( 30 ),
      child: Container(
        width: double.infinity,
        child: urlImg.isEmpty 
          ? const Image(
            image: AssetImage('assets/no-image.png', ),
              fit: BoxFit.cover,
            )
          : FadeInImage(
              placeholder: const AssetImage('assets/jar-loading.gif'), 
              image: NetworkImage( urlImg ),
              fit: BoxFit.cover,
            ),
      ),
    );
  }
}