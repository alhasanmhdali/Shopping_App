import 'package:flutter/material.dart';

import './product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;

  CartItem({
    @required this.product,
    @required this.id,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return _cartItems;
  }

  void addItem(Product prod, {int quantity = 1}) {
    if (_cartItems.containsKey(prod.id)) {
      _cartItems.update(
          prod.id,
          (cartItem) => CartItem(
              product: cartItem.product,
              id: cartItem.id,
              quantity: cartItem.quantity + 1));
    } else {
      _cartItems.putIfAbsent(
        prod.id,
        () => CartItem(
          product: prod,
          id: DateTime.now().toString(),
          quantity: quantity,
        ),
      );
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
      total += _cartItems[key].product.price * _cartItems[key].quantity;
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
          quantity: cartItem.quantity + 1,
        ),
      );
      notifyListeners();
    } else if (operation == 'remove') {
      _cartItems[pId].quantity == 1
          ? removeItem(pId)
          : _cartItems.update(
              pId,
              (cartItem) => CartItem(
                product: cartItem.product,
                id: cartItem.id,
                quantity: cartItem.quantity - 1,
              ),
            );
      notifyListeners();
    }
  }

  void updateProduct(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems.update(
          product.id,
          (cartItem) => CartItem(
              product: product, id: cartItem.id, quantity: cartItem.quantity));
    }
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }
}
