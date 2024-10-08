import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({Key? key}) : super(key: key);

  static const routName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _isOutOfStock = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _value = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    category: Category.coffee,
    isOutOfStock: false,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'isOutOfStock': '',
    'category': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'isOutOfStock': _editedProduct.isOutOfStock.toString(),
          'category': _editedProduct.category.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': ''
        };
      }

      _imageUrlController.text = _editedProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _isOutOfStock.dispose();
    _categoryFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('')) {
        return;
      }
      return null;
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProductToDatabase(_editedProduct)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          title: newValue!,
                          price: _editedProduct.price,
                          isOutOfStock: _editedProduct.isOutOfStock,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          category: _editedProduct.category,
                          id: _editedProduct.id,
                          // isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_isOutOfStock);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than 0.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(newValue!),
                          isOutOfStock: _editedProduct.isOutOfStock,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          category: _editedProduct.category,
                          id: _editedProduct.id,
                          //  isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),

                    Text("Stoc epuizat"),
                    Checkbox(
                      focusNode: _priceFocusNode,
                      value: _editedProduct.isOutOfStock,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;

                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            isOutOfStock: _value,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            category: _editedProduct.category,
                            id: _editedProduct.id,
                            // isFavorite: _editedProduct.isFavorite,
                          );
                        });
                      },
                    ),
                    DropdownButtonFormField<Category>(
                      value: _editedProduct.category,
                      onChanged: (_value) {
                        setState(() {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            isOutOfStock: _editedProduct.isOutOfStock,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            category: _value,
                            // Category.values[int.parse(_value.toString())],
                            id: _editedProduct.id,
                            // isFavorite: _editedProduct.isFavorite,
                          );
                        });
                      },
                      decoration: InputDecoration(labelText: 'Categorie'),
                      items: Category.values.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                    // TextFormField(
                    //   initialValue: _initValues['quantity'],
                    //   decoration: InputDecoration(labelText: 'Quantity'),
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.number,
                    //   focusNode: _quantityFocusNode,
                    //   onFieldSubmitted: (_) {
                    //     FocusScope.of(context)
                    //         .requestFocus(_descriptionFocusNode);
                    //   },
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter the quantity.';
                    //     }
                    //     if (int.tryParse(value) == null) {
                    //       return 'Please enter a valid number.';
                    //     }
                    //     if (int.parse(value) <= 0) {
                    //       return 'Please enter a number greater than 0.';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (newValue) {
                    //     _editedProduct = Product(
                    //       title: _editedProduct.title,
                    //       price: _editedProduct.price,
                    //       isOutOfStock: false,
                    //       description: _editedProduct.description,
                    //       imageUrl: _editedProduct.imageUrl,
                    //       id: _editedProduct.id,
                    //       isFavorite: _editedProduct.isFavorite,
                    //     );
                    //   },
                    // ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Descriere'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Introdu o descriere.';
                        }
                        if (value.length < 10) {
                          return 'Descrierea necesită minim 10 caractere.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          isOutOfStock: _editedProduct.isOutOfStock,
                          description: newValue!,
                          category: _editedProduct.category,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          //    isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          )),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Introdu un link pentru imagine')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Imagine URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Introdu URL-ul unei imageni.';
                              }
                              if (!value.startsWith('blob') &&
                                  !value.startsWith('https')) {
                                return 'Introdu un URL valid.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                isOutOfStock: _editedProduct.isOutOfStock,
                                description: _editedProduct.description,
                                category: _editedProduct.category,
                                imageUrl: newValue!,
                                id: _editedProduct.id,
                                //    isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
