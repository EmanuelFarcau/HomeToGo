import 'package:flutter/foundation.dart';
import 'package:shop_app/models/order_model.dart';
import '../repository/order_repository.dart';

class OrderProvider with ChangeNotifier {
  OrderRepository orderRepository = OrderRepository();

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void getOrders() async {
    var orders = await orderRepository.getItems();
    _orders = [...orders];
  }

  Future<void> addOrderToDatabase(OrderItem orderItem) async {
    return orderRepository.addOrderToDatabase(orderItem);
  }

  Future<void> updateOrder(String id, OrderItem orderItem) async {
    notifyListeners();
    return orderRepository.updateOrder(id, orderItem);
  }

  // void addOrder(List<CartItem> cartProducts, double total) {
  //   var _orderItem = OrderItem(
  //     id: DateTime.now().toString(),
  //     email: "test@test.gmail",
  //     amount: total,
  //     products: cartProducts,
  //     dateTime: DateTime.now(),
  //   );

  //   _orders.insert(
  //     0,
  //     _orderItem,
  //   );
  //   addOrderToDatabase(_orderItem);
  //   notifyListeners();
  // }

}
