import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/food_item.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/order.dart' as cravings; // Add prefix
import '../utils/constants.dart';

class HistoryScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  // Function to update order status to "Delivered" in Firestore
  Future<void> _markOrderAsDelivered(String orderId, BuildContext context) async {
    try {
      final userId = AuthService.currentUser!.id;
      await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .update({'status': 'Delivered'});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order marked as Delivered")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update order status: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to update order status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<List<cravings.Order>>( // Use prefixed Order type
          stream: _firestoreService.fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: kPrimaryColor));
            }
            if (snapshot.hasError) {
              print("Error loading orders: ${snapshot.error}");
              return Center(child: Text("Error loading orders", style: TextStyle(color: kTextColor)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: kTextColor),
                    SizedBox(height: kPadding),
                    Text(
                      "No orders yet",
                      style: TextStyle(fontSize: 18, color: kTextColor),
                    ),
                  ],
                ),
              );
            }

            final orders = snapshot.data!;
            print("Fetched orders: $orders");
            return ListView.builder(
              padding: EdgeInsets.all(kPadding),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(context, orders[index], screenWidth);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, cravings.Order order, double screenWidth) { // Use prefixed Order
    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: kPadding / 2),
      child: ExpansionTile(
        leading: Icon(Icons.receipt, color: kPrimaryColor),
        title: Text(
          "Order #${order.id.substring(0, 8)}",
          style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor),
        ),
        subtitle: Text(
          "Total: ₹${order.total.toStringAsFixed(2)} | ${order.status}",
          style: TextStyle(color: Colors.grey),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
                ),
                SizedBox(height: kPadding / 2),
                ...order.items.map((item) => _buildItemRow(item)).toList(),
                SizedBox(height: kPadding),
                _buildDetailRow("Date", order.date.toString().substring(0, 19), Icons.calendar_today),
                _buildDetailRow("Total", "₹${order.total.toStringAsFixed(2)}", Icons.attach_money),
                _buildDetailRow("Status", order.status, Icons.info),
                _buildDetailRow("Address", order.address ?? "Not specified", Icons.location_on),
                SizedBox(height: kPadding),
                if (order.status != "Delivered")
                  ElevatedButton(
                    onPressed: () => _markOrderAsDelivered(order.id, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Mark as Delivered"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(FoodItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kPadding / 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.name,
            style: TextStyle(fontSize: 14, color: kTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "₹${item.price.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 14, color: kTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kPadding / 2),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor, size: 20),
          SizedBox(width: kPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: kTextColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}