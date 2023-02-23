// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  ///const ProductItem({Key? key}) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: Container(
          height: 40,
          decoration: BoxDecoration(color: Colors.black87),
          child: GridTileBar(
            // leading: Consumer<Product>(
            //   builder: (ctx, product, child) => IconButton(
            //     icon: Icon(
            //         product.isFavorite ? Icons.favorite : Icons.favorite_border),
            //     onPressed: product.toggleFavouriteStatus,
            //     color: Theme.of(context).accentColor,
            //   ),
            // ),

            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              '${product.price.toString()} RON',
              style: TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_basket,
              ),
              onPressed: () {
                cart.addItem(product.id!, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart!',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
