import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-learn-e5189.firebaseio.com/orders.json';
    final response = await http.get(url);
    final loadedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (response == null) {
      return;
    }
    final List<OrderItem> mapedOrders = [];
    loadedOrders.forEach((keyOrder, orderData) {
      mapedOrders.add(
        OrderItem(
          id: keyOrder,
          dateTime: DateTime.parse(orderData['dateTime']),
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (product) => CartItem(
                  id: product['id'],
                  title: product['title'],
                  price: product['price'],
                  quantity: product['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _items = mapedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    const url = 'https://flutter-learn-e5189.firebaseio.com/orders.json';
    final times = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': times.toIso8601String(),
        'products': products
            .map((cartItem) => {
                  'id': cartItem.id,
                  'title': cartItem.title,
                  'price': cartItem.price,
                  'quantity': cartItem.quantity
                })
            .toList(),
      }),
    );
    _items.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        products: products,
        amount: total,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
