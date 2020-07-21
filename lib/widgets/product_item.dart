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
            },
            color: Theme
                .of(context)
                .accentColor,
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
                onPressed: () =>
                    cart.addItem(product.id, product.title, product.price),
                color: Theme
                    .of(context)
                    .accentColor,
              );
              return count == 0 ? shopIcon : GestureDetector(
                onLongPress: () => cart.removeItem(product.id),
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
