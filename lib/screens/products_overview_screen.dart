import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';

import './shopping_cart_screen.dart';

enum SelectedFilter {
  FavoritesOnly,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool onlyFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MobShop'),
        actions: [
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
          PopupMenuButton(
            onSelected: (SelectedFilter filter) {
              setState(() {
                onlyFav = (filter == SelectedFilter.FavoritesOnly);
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Favorite Only'),
                  value: SelectedFilter.FavoritesOnly,
                ),
                PopupMenuItem(
                  child: Text('All'),
                  value: SelectedFilter.All,
                ),
              ];
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(onlyFav),
    );
  }
}
