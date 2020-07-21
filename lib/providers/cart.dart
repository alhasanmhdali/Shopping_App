import 'package:flutter/material.dart';

class CartItem {
  final String product;
  final String id;
  final String item;
  final double price;
  final int quantity;

  CartItem({
    @required this.product,
    @required this.id,
    @required this.item,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (cartItem) => CartItem(
              product: cartItem.product,
              id: cartItem.id,
              item: cartItem.item,
              price: cartItem.price,
              quantity: cartItem.quantity + 1));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartItem(
              product: productId,
              id: DateTime.now().toString(),
              item: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

//  void removeItem(String id) {
//    if (_cartItems.containsKey(id)) {
//      if (_cartItems[id].quantity == 1)
//        _cartItems.remove(id);
//      else
//        _cartItems.update(
//            id,
//            (cartItem) => CartItem(
//                id: cartItem.id,
//                item: cartItem.item,
//                price: cartItem.price,
//                quantity: cartItem.quantity - 1));
//    }
//    notifyListeners();
//  }

  void removeItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  int get getCount {
    return _cartItems.length;
  }

  double get getTotalPrice {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      total += _cartItems[key].price * _cartItems[key].quantity;
    });
    return total;
  }

  int getItemCount(String id) {
    return _cartItems.containsKey(id) ? _cartItems[id].quantity : 0;
  }

  void updateQuantity(String pId, String operation) {
    if (operation == 'add') {
      _cartItems.update(
        pId,
        (cartItem) => CartItem(
          product: cartItem.product,
          id: cartItem.id,
          item: cartItem.item,
          price: cartItem.price,
          quantity: cartItem.quantity + 1,
        ),
      );
      notifyListeners();
    } else if (operation == 'remove') {
      _cartItems[pId].quantity == 1 ? removeItem(pId) : _cartItems.update(
        pId,
        (cartItem) => CartItem(
          product: cartItem.product,
          id: cartItem.id,
          item: cartItem.item,
          price: cartItem.price,
          quantity: cartItem.quantity - 1,
        ),
      );
      notifyListeners();
    }
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }
}
