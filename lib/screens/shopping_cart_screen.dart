import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';

import '../widgets/cart_list_item.dart';

import '../providers/cart.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Consumer<Cart>(
                    builder: (ctx, cart, _) {
                      final int count = cart.getCount;
                      return Text(
                        count <= 1 ? '$count item' : '$count items',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Consumer<Cart>(
                      builder: (ctx, cart, _) =>
                          Text('\$${cart.getTotalPrice.toStringAsFixed(2)}'),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 15),
            child: FlatButton.icon(
              onPressed: () {
                Cart cart = Provider.of<Cart>(context, listen: false);
                if (cart.getCount > 0) {
                  Provider.of<Order>(context, listen: false).addOrder(
                      cart.getTotalPrice, cart.cartItems.values.toList());
                  cart.clear();
                }
              },
              icon: Icon(Icons.shopping_basket),
              label: Text(
                'Checkout',
                style: TextStyle(fontSize: 18),
              ),
              textColor: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Consumer<Cart>(
              builder: (ctx, cart, _) {
                return ListView.builder(
                  itemCount: cart.getCount,
                  itemBuilder: (context, i) {
                    return CartListItem(cart.cartItems.values.toList()[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
