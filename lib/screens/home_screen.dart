import 'package:flutter/material.dart';
import 'package:product_app/models/product_model.dart';
import 'package:product_app/providers/auth_provider.dart';
import 'package:product_app/providers/nav_bar_provider.dart';
import 'package:product_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final productProv = Provider.of<ProductProvider>(context );
    final authProvider = Provider.of<AuthProvider>(context);

    // productProv.onGetProducts();

    final NavBarProvider navbarProvider = Provider.of<NavBarProvider>(context);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Bienvenido: ${ authProvider.stFullName }'),
        actions: [

          IconButton(
            onPressed: () async {
              await authProvider.onLogout();

              Navigator.of(context).pushReplacementNamed('');
            }, 
            icon: const Icon( Icons.logout_outlined )
          )

        ],
      ),

      body: navbarProvider.currentIndex == 0 
        ? _ListProducts( productProv: productProv, )
        : const Center(
          child: Text('Statistics'),
        ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        child: const Icon( Icons.add ),
        onPressed: () {

          productProv.selectedProduct = ProductModel(name: '', available: true, price: 0.00, urlImg: '');
          productProv.loadData = false;
          productProv.pickFile = null;
          productProv.notifier();

          Navigator.pushNamed(context, 'product');

        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: const NavBar(),

    );
  }
}

class _ListProducts extends StatelessWidget {

  final ProductProvider productProv ;
  const _ListProducts({
    Key? key, required this.productProv,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // final productProv = Provider.of<ProductProvider>(context);


    final products = productProv.products;

    if( productProv.loadingList ) {
      return const Center( child: CircularProgressIndicator( color: Colors.indigo, ) );
    }

    return ListView.builder(
      itemCount: productProv.counter,
      itemBuilder: (BuildContext _, int i) {

        final currenProduct = products[i];

        return  GestureDetector(
          child: CardProduct(product: currenProduct ),
          onTap: () {
            productProv.selectedProduct = currenProduct.copy();
            productProv.loadData = true;
            productProv.pickFile = null;
            
            Navigator.of(context).pushNamed('product');
          },
          onLongPress: () {

            productProv.selectedProduct = currenProduct;
            confirmDelete(context, productProv);
          },
        );
      },
    );
  }

  void confirmDelete( BuildContext context, ProductProvider productprov ) {

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text('¿Está seguro de eliminar el producto : ${ productprov.selectedProduct.name }?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),

          actions: [
            TextButton(
              onPressed: () async {
                await productprov.onDeleteProduct();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }, 
              child: productprov.loading 
              ? const CircularProgressIndicator()
              : const Text('Eliminar', style: TextStyle( color: Colors.red ))
            ),

            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancelar', style: TextStyle( color: Colors.black45 ) )
            )
          ]
        );
      }
    );

  }

}