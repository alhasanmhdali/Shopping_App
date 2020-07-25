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
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Confirm Delete'),
              content: Text(
                  'Are you sure you want to remove \"${_cartItem.product.title}\" from your cart?'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text('Yes'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        );
      },
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
        final String id = _cartItem.product.id;
        final String title = _cartItem.product.title;
        final int quantity = _cartItem.quantity;
        final cart = Provider.of<Cart>(context, listen: false);
        cart.removeItem(id);
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('\"$title\" has been removed from your cart!'),
          action: SnackBarAction(
            label: 'undo',
            onPressed: () {
              cart.addItem(_cartItem.product, quantity: quantity);
            },
          ),
          duration: Duration(seconds: 5),
        ));
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(ProductScreen.routeName,
              arguments: _cartItem.product.id);
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
                          '\$${(_cartItem.product.price * _cartItem.quantity).round()}'),
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
                        _cartItem.product.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '\$${_cartItem.product.price} each',
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
                              .updateQuantity(_cartItem.product.id, 'remove'),
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
                          .updateQuantity(_cartItem.product.id, 'add'),
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
