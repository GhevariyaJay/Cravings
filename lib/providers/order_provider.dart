import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/order.dart' as cravings; // Add prefix to disambiguate Order

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  void placeOrder(List<FoodItem> items, double total, String address) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    final order = cravings.Order( // Use prefixed Order
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      total: total,
      date: DateTime.now(),
      status: 'Pending',
      address: address,
      userId: userId,
    );

    try {
      await _firestoreService.placeOrder(order); // Use FirestoreService to place order
      notifyListeners();
    } catch (e) {
      print("Error placing order: $e");
      throw Exception("Failed to place order: $e");
    }
  }

  void clearOrders() {
    // No need to clear Firestore data here; handle in FirestoreService if needed
    notifyListeners();
  }
}