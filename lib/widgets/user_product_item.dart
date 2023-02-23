import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {Key? key, required this.title, required this.imageUrl, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Color.fromARGB(255, 55, 73, 87),
            ),
            IconButton(
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
