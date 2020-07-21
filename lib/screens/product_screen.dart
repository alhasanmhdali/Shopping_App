import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';

import '../widgets/badge.dart';

import './shopping_cart_screen.dart';

class ProductScreen extends StatelessWidget {
  static const String routeName = '/product-page';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    Product product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).getById(id);
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(title: Text(product.title), actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return Badge(
                child: ch,
                value: cart.getCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
              },
            ),
          ),
        ]),
        body: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 2, spreadRadius: 2),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${product.description}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(75, 75, 75, 1),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '\$${product.price}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(75, 75, 75, 1),
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Divider(
                    height: 50,
                    endIndent: 50,
                    indent: 50,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Add to Cart:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(75, 75, 75, 1),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Consumer<Cart>(
                        builder: (context, cart, _) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      onPressed:
                                          cart.getItemCount(product.id) == 0
                                              ? null
                                              : () {
                                                  cart.updateQuantity(
                                                      product.id, 'remove');
                                                },
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      cart.getItemCount(product.id).toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    SizedBox(width: 20),
                                    IconButton(
                                      icon: Icon(Icons.keyboard_arrow_up),
                                      onPressed: () => cart.addItem(product.id,
                                          product.title, product.price),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                child: Text(
                                  '\$${cart.getItemCount(product.id) * product.price}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Consumer<Product>(
          builder: (ctx, prod, _) {
            return FloatingActionButton(
              onPressed: product.favoritePressed,
              child: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            );
          },
        ),
      ),
    );
  }
}
