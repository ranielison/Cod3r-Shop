import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final String _baseUrl = 'https://flutter-cod3r-69173.firebaseio.com';
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      _baseUrl + '/orders.json',
      body: json.encode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map(
                (item) => {
                  'id': item.id,
                  'productId': item.productId,
                  'title': item.title,
                  'quantity': item.quantity,
                  'price': item.price,
                },
              )
              .toList(),
        },
      ),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
