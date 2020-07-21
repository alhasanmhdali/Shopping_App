import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

import '../providers/product.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFav;

  ProductsGrid(this._showFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final List<Product> _items = _showFav ? productsData.favItems : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _items.length,
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: _items[i],
          child: ProductItem(
            _items[i],
          ),
        );
      },
    );
  }
}
