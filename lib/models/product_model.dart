// To parse this JSON data, do
//
//     final productModel = productModelFromMap(jsonString);

import 'dart:convert';

class ProductModel {
    ProductModel({
        this.id,
        required this.name,
        required this.available,
        required this.price,
        required this.urlImg,
        this.publicId = '',
        this.signature = ''
    });

    String? id;
    String name;
    bool available;
    double price;
    String urlImg;

    String publicId;
    String signature;

    factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"] ?? '' ,
        name: json["name"] ?? '',
        available: json["available"] ?? false,
        price: double.parse( json["price"] ) ?? 0.00,
        urlImg: json["urlImg"] ?? '',
        publicId: json["public_id"] ?? '',
        signature: json["signature"] ?? '',
    );

    Map<String, dynamic> toMap() => {
        "id": id ?? '',
        "name": name.toString(),
        "available": available.toString(),
        "price": price.toString(),
        "urlImg": urlImg,
        "publicId": publicId,
        "signature": signature,
    };

    ProductModel copy() => ProductModel( 
      id: id
      , name: name
      , available: available
      , price: price
      , urlImg: urlImg
      , publicId: publicId
      , signature: signature
    );
}
