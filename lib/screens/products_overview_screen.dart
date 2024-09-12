// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../providers/product.dart' as pr;
import '../providers/products.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  //const ProductsOverviewScreen({Key? key}) : super(key: key);
  late List<Product> products;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Products productsProvider = Products();
    Product product = Product(
      id: DateTime.now().toIso8601String(),
      title: 'TestProduct',
      description: 'This is a test',
      price: 14.98,
      isOutOfStock: false,
      category: pr.Category.coffee,
      imageUrl:
          'https://sitechecker.pro/wp-content/uploads/2017/12/URL-meaning.png',
    );
    // productsProvider.addProductToDatabase(product);

    productsProvider.getItems();
    productsProvider.getItemsInStock();
  }

  List<Product>? filteredProducts;

  @override
  Widget build(BuildContext context) {
    products = Provider.of<Products>(context).itemsInStock;

    void showCategory(pr.Category? category) {
      if (category != pr.Category.all) {
        filteredProducts =
            products.where((element) => element.category == category).toList();
      } else {
        filteredProducts = products;
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 55, 73, 87),
      appBar: AppBar(
        title: Text('Home2Go'),
        actions: [
          PopupMenuButton(
            onSelected: (pr.Category? selectedValue) {
              setState(() {
                showCategory(selectedValue);
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Cafea'),
                value: pr.Category.coffee,
              ),
              PopupMenuItem(child: Text('Siropuri'), value: pr.Category.syrups),
              PopupMenuItem(
                  child: Text('Cursuri Barista'), value: pr.Category.courses),
              PopupMenuItem(
                child: Text('Accesorii'),
                value: pr.Category.accesories,
              ),
              PopupMenuItem(
                child: Text('Toate produsele'),
                value: pr.Category.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              label: Text(cart.itemCount.toString()),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(
        _showOnlyFavorites,
        products: filteredProducts == null ? products : filteredProducts!,
      ),
    );
  }
}
