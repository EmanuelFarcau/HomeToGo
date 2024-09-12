import 'package:flutter/foundation.dart';

enum Category { coffee, accesories, courses, syrups, all }

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final bool isOutOfStock;
  final String imageUrl;

  final Category? category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.isOutOfStock,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
        id: map['id'] ?? "",
        title: map['title'] ?? "",
        description: map['description'] ?? "",
        price: map['price'] ?? 0,
        isOutOfStock: map['isOutOfStock'] ?? "",
        imageUrl: map['imageUrl'] ?? "",
        category:
            map['category'] != null ? Category.values[map['category']] : null);
  }

  Map<String, dynamic> toMap(/*[String id = '']*/) {
    return {
      'id': /*id != '' ? id :*/ DateTime.now().toIso8601String(),
      'title': title,
      'description': description,
      'price': price,
      'isOutOfStock': isOutOfStock,
      'imageUrl': imageUrl,
      'category': category?.index,
    };
  }

//  void toggleFavouriteStatus() {
  // /  isFavorite = !isFavorite;
  //   notifyListeners();
  // }

  @override
  String toString() {
    return 'id: $id, title: $title, description: $description, imageUrl: $imageUrl, price: $price, isOutOfStock: $isOutOfStock, category: $category, ';
  }
}
