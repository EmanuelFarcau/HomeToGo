import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/auth_service.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/user_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (ctx) => OrderProvider())
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color.fromARGB(255, 55, 73, 87),
              secondary: Color.fromARGB(222, 209, 202, 172),
              background: Color.fromARGB(255, 55, 73, 87)),
          secondaryHeaderColor: Color.fromARGB(222, 209, 202, 172),
          fontFamily: 'Lato',
        ),
        home: MainPage(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).getItems();
    final productsInStock = Provider.of<Products>(context).getItemsInStock();
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: StreamBuilder<AppUser?>(
          stream: authService.appUser,
          builder: (_, AsyncSnapshot<AppUser?> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final AppUser? user = snapshot.data;
              if (user == null) {
                return AuthScreen();
              } else {
                return FutureBuilder<List<Product>>(
                  future: productsInStock,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ProductsOverviewScreen();
                    } else {
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
                );
              }
              //return user == null ? AuthScreen() : ProductsOverviewScreen();
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            ;
          }),
    );
  }
}
