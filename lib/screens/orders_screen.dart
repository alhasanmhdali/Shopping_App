import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/order_list_item.dart';

import '../widgets/app_drawer.dart';

import '../providers/order.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: Consumer<Order>(
        builder: (ctx, order, ch) {
          return order.orders.length == 0
              ? ch
              : ListView.builder(
                  itemCount: order.orders.length,
                  itemBuilder: (ctx, index) => OrderListItem(order.orders[index]),
                );
        },
        child: Center(
          child: Text(
            'There is no orders yet!',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
