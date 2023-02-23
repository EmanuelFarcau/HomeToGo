import '../providers/cart.dart';

class OrderItem {
  final String id;
  String? email;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String city;
  final String county;
  final String address;

  OrderItem({
    required this.city,
    required this.county,
    required this.address,
    required this.id,
    this.email,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  void setEmail(String _email) {
    this.email = _email;
  }

  factory OrderItem.fromMap(Map<dynamic, dynamic> map) {
    List cartItemsMap = map['products'] as List;
    List<CartItem> cartItems = [];
    for (var element in cartItemsMap) {
      cartItems.add(CartItem.fromMap(element));
    }

    return OrderItem(
      id: map['id'] ?? "",
      email: map['email'] ?? "",
      amount: map['amount'].toDouble(),
      products: cartItems,
      dateTime: DateTime.now(),
      city: map['city'],
      county: map['county'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    var productsListMap = [];
    products.forEach((element) {
      var elementMapped = element.toMap();
      productsListMap.add(elementMapped);
    });
    return {
      'id': DateTime.now().toIso8601String(),
      'email': email,
      'amount': amount.toInt(),
      'products': productsListMap,
      'dateTime': dateTime.toIso8601String(),
      'city': city,
      'county': county,
      'address': address,
    };
  }
}
