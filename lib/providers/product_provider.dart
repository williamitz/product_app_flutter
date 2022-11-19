import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:product_app/models/product_model.dart';
import 'package:product_app/models/response_model.dart';
import 'package:product_app/models/upload_model.dart';
import 'package:product_app/utils/utils.dart';

class ProductProvider with ChangeNotifier {

  ProductProvider(){
    onGetProducts();
  }

  List<ProductModel> _products = [];

  late ProductModel selectedProduct;

  final String _uri = Utils.serverHost;

  final _storage = const FlutterSecureStorage();

  File? pickFile;

  bool _loadData = false;
  bool _loading = false;
  bool _loadingList = false;

  Future<ProductModel?> _updateHttp( ProductModel product, [bool delete = false] ) async {

    try {

      Uri uriHttp = Uri.http( _uri, (_loadData || delete ) ? '/api/product/${ product.id }' : '/api/product' );

      http.Response response;

      final body =  product.toMap();
      final token = await _storage.read(key: 'token') ?? '';
      // final body = json.encode( product.toMap() );

      if( _loadData && !delete ) {

        response = await http.patch( uriHttp, body: body, headers: { 'Authorization': 'Bearer $token' } );
      } else if( !_loadData && delete ){
        response = await http.delete( uriHttp, headers: { 'Authorization': 'Bearer $token' } );

        if (response.statusCode == 200) return product;

      } else {
        response = await http.post( uriHttp, body: body, headers: { 'Authorization': 'Bearer $token' } );
      }

      print('response.statusCode === ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
          final jsonRes = json.decode(response.body) as Map<String, dynamic>;
          print('response.statusCode === $jsonRes');

          return ProductModel( 
            id: jsonRes['id'],
            name: jsonRes['name'], 
            available: jsonRes['available'].toString() == 'true' ? true : false,
            price: double.parse( jsonRes['price'].toString() ),
            urlImg: jsonRes['urlImg']
          );

      } else {
        return null;
      }
      
    } catch (e) {
      throw Exception('Failed execute http $e');
    }

  }

  Future<List<ProductModel>> _getHttp( [int limit = 0, int page = 0] ) async {
    try {

      int offset = 0;

      if( page > 0 ) {

        offset = ( page - 1 ) * limit;

      }

      final token = await _storage.read(key: 'token') ?? '';
      
      Uri uriHttp = Uri.http( _uri, '/api/product', { 'limit': limit.toString(), 'offset': offset.toString() } );
      
      final response = await http.get( uriHttp, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'} );

      print('token === $token');
      print('response.statusCode === ${response.statusCode}');

      if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
            print('response.statusCode === $jsonResponse');
          final responseMap = ResponseModel.fromMap( jsonResponse );

          final products = responseMap.data;

          return products.map((e) => ProductModel.fromMap( e ) ).toList();

      } else {
        return [];
      }

      // return [];


    } catch (e) {
      print('catch ==== $e');
      // throw new Exception('Bad request to get http');
      return [];
    }
  }

  Future<UploadResponseModel?> _uploadImg() async {

    try {

      if( pickFile == null ) return null;
      
      final Uri uri = Uri.https( 'api.cloudinary.com', 'v1_1/dklfl8tcn/image/upload', { "upload_preset": "ml_default" } );
      // https://api.cloudinary.com/v1_1/dklfl8tcn/image/upload?upload_preset=ml_default

      final uploadRequest = http.MultipartRequest( 'POST', uri );

      final file = await http.MultipartFile.fromPath( 'file', pickFile!.path );
      
      uploadRequest.files.add( file );

      final streamResponse = await uploadRequest.send();
      final response = await http.Response.fromStream( streamResponse );

      if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
          final responseMap = UploadResponseModel.fromMap( jsonResponse );

          return responseMap;


      } else {
        return null;
      }
      
    } catch (e) {
      print('Error to upload file ============== $e');
      return null;
    }
  }

  onAddProduct( ) async {

    _loading = true;
    notifyListeners();

    if( pickFile != null ) {
      
      final uploadRes = await _uploadImg();

      if( uploadRes != null ) {
        selectedProduct.urlImg = uploadRes.secureUrl;
        selectedProduct.publicId = uploadRes.publicId;
        selectedProduct.signature = uploadRes.signature;
      }

    }

    final productDB = await _updateHttp( selectedProduct );

    if( productDB != null ) {
      selectedProduct.id = productDB.id;
      _products.add( selectedProduct );
    }
    
    // _loading = false;
    _onReset();

    notifyListeners();

  }

  onUpdateProduct( ) async {
    
    _loadData = true;
    _loading = true;
    notifyListeners();

    if( pickFile != null ) {
      
      final uploadRes = await _uploadImg();

      if( uploadRes != null ) {
        selectedProduct.urlImg = uploadRes.secureUrl;
        selectedProduct.publicId = uploadRes.publicId;
        selectedProduct.signature = uploadRes.signature;
      }

    }

    final productDB = await _updateHttp( selectedProduct );

    if( productDB != null ) {
      final index = _products.indexWhere((element) => element.id == selectedProduct.id );
      
      _products[ index ].name = productDB.name;
      _products[ index ].price = productDB.price;
      _products[ index ].available = productDB.available;
      _products[ index ].urlImg = productDB.urlImg;
    }

    // selectedProduct.id = productDB!.id ?? 'xd';

    
    // _loading = false;
    // _loadData = false;

    _onReset();


    notifyListeners();

  }

  onDeleteProduct() async {
    _loading = true;
    notifyListeners();

    await _updateHttp( selectedProduct, true );

    // selectedProduct.id = productDB!.id ?? 'xd';

    _products = _products.where((element) => element.id != selectedProduct.id ).toList();
    
    _loading = false;
    notifyListeners();
  }

  Future<void> onGetProducts() async {
    
    _loadingList = true;
    notifyListeners();

    final products = await _getHttp();
    _products = [];
    _products.addAll( products );

    _loadingList = false;
    notifyListeners();

  }

  List<ProductModel> get products => _products; 

  int get counter => _products.length;
  bool get loading => _loading;

  set loadData( bool val ) {
    _loadData = val;
    notifyListeners();
  }

  bool get loadData => _loadData;
  bool get loadingList => _loadingList;

  set imgUrl( String path ) {
    selectedProduct.urlImg = path;

    pickFile = File.fromUri( Uri( path: path ) );
    notifyListeners();
  }

  void _onReset() {
    _loading = false;
    _loadData = false;
    selectedProduct = ProductModel(name: '', available: true, price: 0.00, urlImg: '');
  }

  notifier() {
    notifyListeners();
  }



}