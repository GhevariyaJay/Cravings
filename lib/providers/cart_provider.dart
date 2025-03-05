import 'package:flutter/material.dart';
import '../models/food_item.dart';

class CartItem {
  final FoodItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = []; // Private field

  List<FoodItem> get cartItems => _cartItems.map((cartItem) => cartItem.item).toList();

  double get totalAmount => _cartItems.fold(0, (total, cartItem) => total + (cartItem.item.price * cartItem.quantity));

  void addToCart(FoodItem item) {
    final existingCartItem = _cartItems.firstWhere((cartItem) => cartItem.item.id == item.id, orElse: () => CartItem(item: item));
    if (_cartItems.contains(existingCartItem)) {
      existingCartItem.quantity++;
    } else {
      _cartItems.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _cartItems.removeWhere((cartItem) => cartItem.item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Public method to get CartItem by item ID for external access
  CartItem getCartItemById(String id) {
    return _cartItems.firstWhere((cartItem) => cartItem.item.id == id, orElse: () => CartItem(item: FoodItem(id: id, name: '', price: 0, imageUrl: ''), quantity: 1));
  }
}