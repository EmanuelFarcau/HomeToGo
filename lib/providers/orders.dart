import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';

import '../models/order_model.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          email: "test@test.gmail",
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
          city: "Oradea",
          county: "Bihor",
          address: "Nufarul"),
    );
    notifyListeners();
  }
}
