import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final int quantity;
  final double price;
  final String title;

  CartItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.title,
  });

  factory CartItem.fromMap(Map<dynamic, dynamic> map) {
    return CartItem(
      id: map['id'] ?? "",
      quantity: map['quantity'],
      price: map['price'].toDouble(),
      title: map['title'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': DateTime.now().toIso8601String(),
      'quantity': quantity,
      'price': price,
      'title': title,
    };
  }

  @override
  String toString() {
    return 'id: $id, quantity: $quantity, price: $price, title: $title ';
  }
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // int productQuantity(String productId) {
  //   if (_items.containsKey(productId)) {
  //      var quantity =
  //   }

  //   return quantity;
  // }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity..
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: (existingCartItem.id),
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price,
              title: existingCartItem.title));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
