import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cravings1/services/auth_service.dart'; // Adjust path as needed
import '../models/order.dart' as cravings; // Add prefix to disambiguate Order

class FirestoreService {
  Stream<List<cravings.Order>> fetchOrders() { // Use prefixed Order
    final userId = AuthService.currentUser?.id; // Use ?. to handle null safely
    if (userId == null) {
      print("No user logged in, returning empty order stream"); // Debug log
      return Stream.value([]); // Return empty list if no user is logged in
    }

    print("Fetching orders for userId: $userId"); // Debug log
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Firestore snapshot data: ${snapshot.docs.map((doc) => doc.data())}"); // Debug log
      return snapshot.docs
          .map((doc) => cravings.Order.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)) // Use prefixed Order
          .toList();
    })
        .handleError((error) {
      print("Firestore error: $error"); // Log errors
      return []; // Return empty list on error to prevent crashes
    });
  }

  Stream<List<cravings.Order>> fetchAllOrders() { // Use prefixed Order
    print("Fetching all orders for admin..."); // Debug log
    return FirebaseFirestore.instance
        .collectionGroup('orders') // Fetch all orders across all users
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print("All orders snapshot data: ${snapshot.docs.map((doc) => doc.data())}"); // Debug log
      return snapshot.docs
          .map((doc) => cravings.Order.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)) // Use prefixed Order
          .toList();
    })
        .handleError((error) {
      print("Firestore error fetching all orders: $error"); // Log errors
      return []; // Return empty list on error to prevent crashes
    });
  }

  Future<void> placeOrder(cravings.Order order) async { // Use prefixed Order
    final userId = AuthService.currentUser?.id;
    if (userId == null) {
      throw Exception("User not logged in");
    }
    print("Placing order for userId: $userId with ID: ${order.id}"); // Debug log
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(order.id)
        .set(order.toFirestore());
  }
}