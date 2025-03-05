class FoodItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int? quantity; // Added quantity field (optional, nullable)

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity, // Default can be null or 1
  });
}