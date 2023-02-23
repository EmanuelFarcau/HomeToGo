import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../api/firebase-api.dart';
import './product.dart';

class Products with ChangeNotifier {
  Api productApi = Api('products');

  List<Product> _items = [];
  List<Product> _itemsInStock = [];

  var _showFavoritesOnly = false;

  List<Product> get items {
    getItems();
    return [..._items];
  }

  List<Product> get itemsInStock {
    getItems();
    getItemsInStock();
    return [..._itemsInStock];
  }

  Stream<List<Product>> readProducts() {
    var snapshots =
        FirebaseFirestore.instance.collection('products').snapshots();

    var x = snapshots.map((snapshot) => snapshot.docs.map((doc) {
          print('Product mapped: ${Product.fromMap(doc.data())}');
          return Product.fromMap(doc.data());
        }).toList());

    return x;
  }

  Future<List<Product>> getItemsInStock() async {
    await getItems();
    var docData = _items;

    _itemsInStock =
        docData.where((element) => element.isOutOfStock == false).toList();
    return _itemsInStock;
  }

  Future<List<Product>> getItems() async {
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');

    QuerySnapshot querySnapshot = await _products.get();
    final docData = querySnapshot.docs.map((doc) {
      Map<dynamic, dynamic> object = doc.data() as Map;
      return Product.fromMap(object);
    }).toList();
    _items = docData;

    return docData;
  }

  // List<Product> get favoriteItems {
  //   return _items.where((element) => element.isFavorite).toList();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProductToDatabase(Product product) async {
    var newId;
    return productApi
        .addDocument(product.toMap())
        .then((value) => print("Product Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var product = await FirebaseFirestore.instance
        .collection('products')
        .where('id', isEqualTo: id)
        .get()
        .then((snapshot) {
      return snapshot.docs[0];
    });
    // var y = await FirebaseFirestore.instance
    //     .collection('products')
    //     .doc(product.id)
    //     .update(newProduct, id);

    productApi.updateDocument(newProduct.toMap(), product.id);
    notifyListeners();
  }

  void deleteProduct(String id) async {
    // ignore: list_remove_unrelated_type
    var x = await FirebaseFirestore.instance
        .collection('products')
        .where('id', isEqualTo: id)
        .get()
        .then((snapshot) {
      return snapshot.docs[0];
    });
    var y = await FirebaseFirestore.instance
        .collection('products')
        .doc(x.id)
        .delete();

    notifyListeners();
  }
}
