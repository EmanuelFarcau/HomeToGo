// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:shop_app/providers/order_provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../providers/products.dart';
import '../widgets/cart_item.dart';
import './edit_product_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String _city;
  late String _county;
  late String _address;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cumpărăturile mele'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Color.fromARGB(255, 55, 73, 87),
                  ),
                  TextButton(
                    onPressed: () {
                      final isValid = formKey.currentState!.validate();

                      if (!isValid) {
                        return;
                      }
                      formKey.currentState!.save();

                      var _orderItem = OrderItem(
                        id: DateTime.now().toIso8601String(),
                        amount: cart.totalAmount,
                        products: cart.items.values.toList(),
                        dateTime: DateTime.now(),
                        city: _city,
                        county: _county,
                        address: _address,
                      );

                      Provider.of<OrderProvider>(context, listen: false)
                          .addOrderToDatabase(_orderItem);
                      cart.clear();
                    },
                    child: Text(
                      'Comanda acum!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 55, 73, 87),
                      ),
                    ),
                    //style: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Oras'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _city = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Judet'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _county = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Adresa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _address = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 6,
          ),
          // Form(child: ListView()),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (BuildContext ctx, int i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price,
                title: cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
