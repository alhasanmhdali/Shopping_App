import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart';

class OrderListItem extends StatefulWidget {
  final OrderItem order;

  OrderListItem(this.order);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        children: [
          ListTile(
            title: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '\$${widget.order.amount}',
            ),
            trailing: IconButton(
              icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: widget.order.products.length * 40.0 ,
              child: ListView(
                children: widget.order.products.map((prod) {
                  return Column(
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.item,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${prod.quantity} x    \$${prod.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
