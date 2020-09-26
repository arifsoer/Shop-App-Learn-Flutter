import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = 'https://flutter-learn-e5189.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedProducts =
          json.decode(response.body) as Map<String, dynamic>;
      if (response == null) {
        return;
      }
      List<Product> _tempProduct = [];
      extractedProducts.forEach((prodId, prodData) {
        _tempProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          description: prodData['description'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = _tempProduct;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://flutter-learn-e5189.firebaseio.com/products.json';
    var body = {
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite
    };
    try {
      final response = await http.post(url, body: json.encode(body));
      var newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> update(String productid, Product editedProduct) async {
    final url =
        'https://flutter-learn-e5189.firebaseio.com/products/$productid.json';
    final index = _items.indexWhere((item) => item.id == productid);
    if (index >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': editedProduct.title,
            'price': editedProduct.price,
            'description': editedProduct.description,
            'imageUrl': editedProduct.imageUrl
          }));
      _items[index] = editedProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> delete(String id) async {
    final url = 'https://flutter-learn-e5189.firebaseio.com/products/$id.json';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var deletedProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, deletedProduct);
      notifyListeners();
      throw HttpException('Delete Failed!');
    }
    deletedProduct = null;
  }
}
