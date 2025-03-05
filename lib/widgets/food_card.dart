import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';

class FoodCard extends StatelessWidget {
  final FoodItem item;

  FoodCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(item.imageUrl)),
        title: Text(item.name),
        subtitle: Text("\$${item.price.toStringAsFixed(2)}"),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart, color: kPrimaryColor),
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false).addToCart(item);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${item.name} added to cart")));
          },
        ),
      ),
    );
  }
}