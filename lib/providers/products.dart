import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String _baseUrl = 'https://flutter-cod3r-69173.firebaseio.com';

  int get itemsCount => _items.length;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get(
      _baseUrl + '/products.json',
    );

    Map<String, dynamic> data = json.decode(response.body);
    if (data != null) {
      data.forEach(
        (productId, productData) {
          _items.add(
            Product(
              id: json.decode(response.body)['name'],
              title: productData['title'],
              price: productData['price'],
              description: productData['description'],
              imageUrl: productData['imageUrl'],
              isFavorite: productData['isFavorite'],
            ),
          );
        },
      );
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      _baseUrl + '/products.json',
      body: json.encode(
        {
          'title': newProduct.title,
          'price': newProduct.price,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'isFavorite': newProduct.isFavorite,
        },
      ),
    );

    _items.add(
      Product(
        id: json.decode(response.body)['name'],
        title: newProduct.title,
        price: newProduct.price,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
      ),
    );

    notifyListeners();
  }

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }
}
