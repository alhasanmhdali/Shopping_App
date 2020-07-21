import 'package:flutter/material.dart';

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
              if (currentRoute == '/')
                Navigator.of(context).pop();
              else
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
              if (currentRoute == OrdersScreen.routeName)
                Navigator.of(context).pop();
              else
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
