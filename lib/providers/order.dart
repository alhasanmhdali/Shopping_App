import 'package:flutter/material.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime date;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.date,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(double totalAmount, List<CartItem> items) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: totalAmount,
        products: items,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
