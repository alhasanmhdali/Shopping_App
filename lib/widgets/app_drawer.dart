import 'package:flutter/material.dart';

import '../screens/user_products.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context).settings.name;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            selected: currentRoute == '/',
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (currentRoute != '/')
                Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            selected: currentRoute == OrdersScreen.routeName,
            leading: Icon(Icons.payment),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (currentRoute != OrdersScreen.routeName)
                currentRoute == '/'
                    ? Navigator.of(context).pushNamed(OrdersScreen.routeName)
                    : Navigator.of(context)
                        .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            selected: currentRoute == UserProducts.routeName,
            leading: Icon(Icons.category),
            title: Text(
              'Products',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (currentRoute != UserProducts.routeName)
                currentRoute == '/'
                    ? Navigator.of(context).pushNamed(UserProducts.routeName)
                    : Navigator.of(context)
                        .pushReplacementNamed(UserProducts.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
