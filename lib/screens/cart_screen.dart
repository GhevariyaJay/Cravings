import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 // Ensure this import exists for FoodItem definition
import '../models/food_item.dart';
import '../models/food_item.dart' as cravings show FoodItem;
import '../services/payment_service.dart';
import '../providers/cart_provider.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../models/order.dart' as cravings; // Add prefix if referencing Order
import '../utils/constants.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _selectedPaymentMode = 'Online';
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: cart.cartItems.isEmpty
          ? Center(child: Text("Cart is empty", style: TextStyle(color: kTextColor)))
          : Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(kPadding),
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cart.cartItems[index];
                  final cartItem = cart.getCartItemById(item.id);
                  return Card(
                    elevation: kCardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: kPadding / 2),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood, size: 50),
                        ),
                      ),
                      title: Text(item.name, style: TextStyle(color: kTextColor)),
                      subtitle: Text(
                        "₹${item.price.toStringAsFixed(2)} x ${cartItem.quantity}",
                        style: TextStyle(color: kTextColor),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add, color: kPrimaryColor),
                            onPressed: () {
                              cart.addToCart(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${item.name} added to cart")),
                              );
                            },
                            tooltip: 'Add More',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cart.removeItem(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${item.name} removed from cart")),
                              );
                            },
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Delivery Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: kPadding / 2),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "Enter your address",
                      labelStyle: TextStyle(color: kTextColor.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: kTextColor.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: TextStyle(color: kTextColor),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your delivery address";
                      } else if (value.length < 10) {
                        return "Address must be at least 10 characters long";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: kPadding),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: kPadding),
                  Text(
                    "Total: ₹${cart.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: kPadding),
                  DropdownButton<String>(
                    value: _selectedPaymentMode,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPaymentMode = newValue!;
                      });
                    },
                    items: <String>['Online', 'Cash on Delivery']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: kTextColor)),
                      );
                    }).toList(),
                    isExpanded: true,
                    underline: Container(height: 1, color: kPrimaryColor),
                  ),
                  SizedBox(height: kPadding),
                  _isLoading
                      ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
                      : ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        setState(() {
                          _errorMessage = "Please provide a valid address.";
                        });
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });

                      try {
                        final userId = AuthService.currentUser?.id;
                        if (userId == null) {
                          setState(() {
                            _errorMessage = "User not logged in.";
                            _isLoading = false;
                          });
                          return;
                        }

                        // Corrected to use cravings.FoodItem
                        final order = cravings.Order(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          items: cart.cartItems.map((item) => cravings.FoodItem(
                            id: item.id,
                            name: item.name,
                            price: item.price,
                            imageUrl: item.imageUrl,
                            quantity: cart.getCartItemById(item.id).quantity, // Assume CartProvider tracks quantity
                          )).toList(),
                          total: cart.totalAmount,
                          date: DateTime.now(),
                          status: 'Pending',
                          address: _addressController.text,
                          userId: userId,
                        );

                        if (_selectedPaymentMode == 'Online') {
                          bool success = await PaymentService.processPayment(cart.totalAmount);
                          if (success) {
                            await FirestoreService().placeOrder(order); // Use FirestoreService
                            cart.clearCart();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Order placed successfully")),
                            );
                          } else {
                            setState(() {
                              _errorMessage = "Payment failed. Please try again.";
                              _isLoading = false;
                            });
                          }
                        } else {
                          await FirestoreService().placeOrder(order); // Use FirestoreService
                          cart.clearCart();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order placed with Cash on Delivery")),
                          );
                        }
                      } catch (e) {
                        setState(() {
                          _errorMessage = "An error occurred: $e";
                          _isLoading = false;
                        });
                        print("Error placing order: $e");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _selectedPaymentMode == 'Online'
                          ? "Pay ₹${cart.totalAmount.toStringAsFixed(2)}"
                          : "Place Order (COD)",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}