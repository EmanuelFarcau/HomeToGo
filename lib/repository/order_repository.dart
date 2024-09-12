import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/api/firebase-api.dart';
import 'package:shop_app/models/order_model.dart';


class OrderRepository {
  Api orderApi = Api('orders');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<OrderItem>> getItems() async {
    CollectionReference _orders =
        FirebaseFirestore.instance.collection('orders');

    QuerySnapshot querySnapshot = await _orders.get();
    final docData = querySnapshot.docs.map((doc) {
      Map<dynamic, dynamic> object = doc.data() as Map;
      return OrderItem.fromMap(object);
    }).toList();
    // _items = await docData;
    var user = _firebaseAuth.currentUser;
    var email = user?.email;
    var ordersByCurrentUser =
        docData.where((element) => element.email == email).toList();

    return ordersByCurrentUser;
  }

  Future<void> addOrderToDatabase(OrderItem orderItem) async {
    var currentUserEmail = _firebaseAuth.currentUser?.email;
    orderItem.setEmail(currentUserEmail!);



    return orderApi
        .addDocument(orderItem.toMap())
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add Order: $error"));
  }

  Future<void> updateOrder(String id, OrderItem orderItem) async {
    var order = await FirebaseFirestore.instance
        .collection('orders')
        .where('id', isEqualTo: id)
        .get()
        .then((snapshot) {
      return snapshot.docs[0];
    });

    orderApi.updateDocument(orderItem.toMap(), order.id);
  }
}
