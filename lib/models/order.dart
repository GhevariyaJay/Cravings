import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_item.dart';

class Order {
  final String id;
  final List<FoodItem> items; // List of FoodItem with quantities
  final double total;
  final DateTime date;
  final String status;
  final String? address;
  final String userId;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
    this.address,
    required this.userId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'items': items.map((item) => {
        'id': item.id,
        'name': item.name,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'quantity': item.quantity, // Include quantity in Firestore
      }).toList(),
      'total': total,
      'timestamp': date,
      'status': status,
      'address': address,
      'userId': userId,
    };
  }

  factory Order.fromFirestore(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      items: (data['items'] as List<dynamic>).map((item) => FoodItem(
        id: item['id'],
        name: item['name'],
        price: (item['price'] as num).toDouble(),
        imageUrl: item['imageUrl'] ?? '',
        quantity: (item['quantity'] as num?)?.toInt() ?? 1, // Default to 1 if null
      )).toList(),
      total: (data['total'] as num).toDouble(),
      date: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pending',
      address: data['address'] as String?,
      userId: data['userId'] as String,
    );
  }
}