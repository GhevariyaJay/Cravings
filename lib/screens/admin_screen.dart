import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/food_item.dart' as cravings;
import '../services/firestore_service.dart';
import '../models/order.dart' as cravings; // Add prefix to disambiguate Order
import '../utils/constants.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin - Received Orders", style: TextStyle(fontSize: 20)),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 24),
            onPressed: () {
              print("Refreshing orders...");
              setState(() {}); // Trigger rebuild
            },
            tooltip: 'Refresh Orders',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: StreamBuilder<List<cravings.Order>>( // Use prefixed Order type
            stream: _firestoreService.fetchAllOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print("Waiting for orders to load...");
                return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
              }
              if (snapshot.hasError) {
                print("Detailed error loading orders: ${snapshot.error}");
                print("Stack trace: ${snapshot.stackTrace}");
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 80, color: Colors.red),
                      const SizedBox(height: kPadding),
                      const Text(
                        "Error Loading Orders",
                        style: TextStyle(fontSize: 20, color: kTextColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: kPadding / 2),
                      Text(
                        "Details: ${snapshot.error}",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: kPadding),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Retry", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                print("No orders found in Firestore");
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: kTextColor),
                      SizedBox(height: kPadding),
                      Text(
                        "No Orders Received Yet",
                        style: TextStyle(fontSize: 20, color: kTextColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }

              final orders = snapshot.data!;
              print("Orders loaded successfully: ${orders.length}");
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Horizontal scroll for wide tables
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 16.0, // Improved spacing between columns
                    dataRowHeight: 60.0, // Increased row height for readability
                    headingRowHeight: 50.0, // Increased heading height
                    columns: const [
                      DataColumn(label: Text("Order ID", style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor))),
                      DataColumn(label: Text("User", style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor))),
                      DataColumn(label: Text("Items (Qty)", style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor))), // Updated column name
                      DataColumn(label: Text("Total", style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor))),
                      DataColumn(label: Text("Address", style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor))),
                      DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor))),
                      DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor))),
                    ],
                    rows: orders.map((order) => _buildOrderRow(order, screenWidth)).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  DataRow _buildOrderRow(cravings.Order order, double screenWidth) { // Use prefixed Order
    return DataRow(
      cells: [
        DataCell(
          Text(
            order.id.substring(0, 8),
            style: TextStyle(fontSize: 14, color: kTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            order.userId,
            style: TextStyle(fontSize: 14, color: kTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          SizedBox(
            width: screenWidth < 600 ? 150 : 200, // Increased width for items with quantities
            child: Text(
              _formatItemsWithQuantity(order.items), // New function to format items with quantities
              style: TextStyle(fontSize: 14, color: kTextColor),
              maxLines: 2, // Allow two lines for readability
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Text(
            "₹${order.total.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 14, color: kTextColor),
          ),
        ),
        DataCell(
          Text(
            order.address ?? "Not specified",
            style: TextStyle(fontSize: 14, color: kTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            order.status,
            style: TextStyle(
              fontSize: 14,
              color: order.status == 'Delivered' ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            order.date.toString().substring(0, 16),
            style: TextStyle(fontSize: 14, color: kTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // New function to format items with their quantities
  String _formatItemsWithQuantity(List<cravings.FoodItem> items) {
    return items.map((item) {
      // Corrected to use item.name (property access, not conditional)
      final quantity = item.quantity ?? 1; // Default to 1 if quantity is not provided
      return '${item.name} (Qty: $quantity)';
    }).join(", ");
  }
}