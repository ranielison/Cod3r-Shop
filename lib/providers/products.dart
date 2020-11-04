import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  //bool _showFavoriteOnly = false;

  int get itemsCount => _items.length;

  List<Product> get items {
    /*if (_showFavoriteOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    }*/
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  /*void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }*/

  void addProduct(Product newProduct) {
    _items.add(
      Product(
        id: Random().nextDouble().toString(),
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
}
