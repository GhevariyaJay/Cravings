import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/constants.dart';

class OrderTile extends StatelessWidget {
  final Order order;

  OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text("Order #${order.id.substring(0, 8)}"),
        subtitle: Text("Total: \$${order.total.toStringAsFixed(2)} | Status: ${order.status}"),
        trailing: Text(order.date.toString().substring(0, 10)),
      ),
    );
  }
}