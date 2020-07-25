import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';

import '../providers/products_provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

import '../screens/product_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (ctx, product, _) {
                return Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                );
              },
            ),
            onPressed: () {
              product.favoritePressed();
              Provider.of<ProductsProvider>(context, listen: false)
                  .favUpdated();
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(product.isFavorite
                    ? '\"${product.title}\" added to favorite!'
                    : '\"${product.title}\" removed from favorite!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    product.favoritePressed();
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Cart>(
            builder: (_, cart, ch) {
              int count = cart.getItemCount(product.id);
              Widget shopIcon = IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  cart.addItem(product);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '\"${product.title}\" has been added to your cart!'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.updateQuantity(product.id, 'remove');
                        Scaffold.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ));
                },
                color: Theme.of(context).accentColor,
              );
              return count == 0
                  ? shopIcon
                  : GestureDetector(
                      onLongPress: () {
                        final int count = cart.getItemCount(product.id);
                        cart.removeItem(product.id);
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('$count \"${product.title}\" has been removed from your cart!'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              cart.addItem(product, quantity: count);
                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ));
                      },
                      child: Badge(
                        value: count.toString(),
                        color: Colors.white,
                        child: shopIcon,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
