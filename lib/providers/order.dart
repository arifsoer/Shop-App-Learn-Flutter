import 'package:flutter/foundation.dart';

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

  void addOrder(List<CartItem> products, double total) {
    _items.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        products: products,
        amount: total,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
