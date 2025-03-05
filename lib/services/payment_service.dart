class PaymentService {
  static Future<bool> processPayment(double amount) async {
    await Future.delayed(Duration(seconds: 2));
    return true; // Mock success
  }
}