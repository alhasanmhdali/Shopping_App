import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_screen.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final CartItem _cartItem;

  CartListItem(this._cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_cartItem.id),
      direction: DismissDirection.endToStart,
      background: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Theme.of(context).errorColor,
        child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30,
              ),
            )),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(_cartItem.product);
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductScreen.routeName, arguments: _cartItem.product);
        },
        splashColor: Theme.of(context).primaryColor,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 24,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text(
                          '\$${(_cartItem.price * _cartItem.quantity).round()}'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _cartItem.item,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '\$${_cartItem.price} each',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: (_cartItem.quantity == 1)
                          ? null
                          : () => Provider.of<Cart>(context, listen: false)
                              .updateQuantity(_cartItem.product, 'remove'),
                      icon: Icon(
                        Icons.remove,
                        size: 18,
                      ),
                    ),
                    Text(
                      _cartItem.quantity.toString(),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Provider.of<Cart>(context, listen: false)
                          .updateQuantity(_cartItem.product, 'add'),
                      icon: Icon(
                        Icons.add,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
