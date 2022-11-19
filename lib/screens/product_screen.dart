import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:product_app/providers/product_form_provider.dart';
import 'package:product_app/ui/input_decorations.dart';

import '../providers/product_provider.dart';
import '../widgets/widgets.dart';

class ProductScreen extends StatelessWidget {

  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final productProv = Provider.of<ProductProvider>(context);

    return  ChangeNotifierProvider(
      create: (context) => ProductFormProvider( productProv.selectedProduct ),
      child: _ProductBody( productProv: productProv ),
    );
  }
}

class _ProductBody extends StatelessWidget {
  const _ProductBody({
    Key? key,
    required this.productProv,
  }) : super(key: key);

  final ProductProvider productProv;

  @override
  Widget build(BuildContext context) {

    ProductFormProvider productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
            
              Stack(
                children: [

                  ProductImage( urlImg: productProv.selectedProduct.urlImg ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: IconButton(
                      onPressed: () { 
                        Navigator.of(context).pop();
                        productProv.loadData = false;
                      }, 
                      icon: const Icon( Icons.arrow_back_ios_new_outlined, size: 40, color: Colors.white, )
                    )
                  ),

                  Positioned(
                    top: 30,
                    right: 30,
                    child: IconButton(
                      onPressed: () async  {

                        final ImagePicker _picker = ImagePicker();

                        final XFile? pickFile = await _picker.pickImage( 
                              source: ImageSource.camera,
                              imageQuality: 100
                              );
                        if( pickFile == null ) return;

                        productProv.imgUrl = pickFile.path;
                        
                      }, 
                      icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.white, )
                    )
                  ),

                ],                  

              ),
              
              _ProductForm( productForm: productForm,),

              const SizedBox(
                height: 100,
              )
            
            ],
          ),
        ),
      ),
    ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: productProv.loading 
          ? null 
          : () async {

          productProv.selectedProduct = productForm.product;
          
          if( productForm.isValidForm() == false ) return;

          if( productProv.loadData == true ){
            await productProv.onUpdateProduct();
          } else {
            await productProv.onAddProduct();
          }


          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();

        },
        child: productProv.loading ?  const CircularProgressIndicator( color: Colors.white, ) : const Icon( Icons.save_outlined ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {

     
  final ProductFormProvider productForm;

  const _ProductForm({
    Key? key, required this.productForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Container(
        margin: const EdgeInsets.symmetric( horizontal: 10 ),
        padding: const EdgeInsets.symmetric( horizontal: 20 ),
        width: double.infinity,
        // height: 200,

        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only( bottomLeft: Radius.circular(30), bottomRight:  Radius.circular(30) )
        ),

        child: Form(
          key: productForm.formKey,
          child: Column(
            children: [

              const SizedBox( height: 10 ),

              TextFormField(

                decoration: InputDecorations.loginDecoration(
                  icon: Icons.shopping_bag_outlined, 
                  labelText: 'Nombre'
                ),
                initialValue: productForm.product.name,
                onChanged: (value) => productForm.product.name = value,
                validator: (value) {
                  if( value == null || value.length < 1 ) return 'Requerido';
                  return null;
                },
              ),

              const SizedBox( height: 20 ),

              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecorations.loginDecoration(
                  icon: Icons.price_check_outlined, 
                  labelText: 'Precio'
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                initialValue: productForm.product.price.toString(),
                onChanged: (value) {

                  if( double.tryParse( value ) == null ){
                    productForm.product.price = 0.0;
                  } else {
                    productForm.product.price = double.parse( value );
                  }

                },
                validator: (value) {
                  if( value == null ) return 'Requerido';
                  return null;
                },

              ),

              const SizedBox( height: 20 ),

              SwitchListTile.adaptive(
                value: productForm.product.available, 
                title: const Text('Disponible'),
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) => productForm.available = value, 
              ),

              const SizedBox( height: 30 ),
            ],
          )
        ),
    );
  }
}