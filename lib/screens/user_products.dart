import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/cart.dart';

import './edit_product.dart';

import '../widgets/app_drawer.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    ProductsProvider _products = Provider.of<ProductsProvider>(context);
    void deleteProduct(int i) {
      showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text(
                'Are you sure you want to delete "${_products.items[i].title}" from your product list?'),
            actions: [
              FlatButton(
                onPressed: () {
                  _products.removeProduct(_products.items[i].id);
                  Navigator.of(ctx).pop();
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(_products.items[i].imageUrl),
                      radius: 30,
                    ),
                    title: Text(_products.items[i].title),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  EditProduct.routeName,
                                  arguments: _products.items[i]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_forever),
                            onPressed: () {
                              deleteProduct(i);
                              Provider.of<Cart>(context, listen: false)
                                  .removeItem(_products.items[i].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: _products.items.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed(EditProduct.routeName);
        },
      ),
    );
  }
}
