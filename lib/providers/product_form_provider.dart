import 'package:flutter/material.dart';
import 'package:product_app/models/product_model.dart';

class ProductFormProvider with ChangeNotifier {
  
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  ProductModel product;

  ProductFormProvider( this.product );

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  set available( bool val ) {
    product.available = val;

    notifyListeners();
  }

  set name( String val ) {
    product.name = val;

    notifyListeners();
  }

}