import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _focusPreco = FocusNode();
  final _focusDescription = FocusNode();
  final _focusImageUrl = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _focusImageUrl.addListener(updateImageUrl);
  }

  bool _isValidImageUrl(String url) {
    bool startsWithHttp = url.toLowerCase().startsWith('http://');
    bool startsWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startsWithHttp || startsWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  void updateImageUrl() {
    if (_isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  void _saveForm() {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      final newProduct = Product(
        id: Random().nextDouble().toString(),
        title: _formData['title'],
        price: _formData['price'],
        description: _formData['description'],
        imageUrl: _formData['imageUrl'],
      );

      Provider.of<Products>(context, listen: false).addProduct(newProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _focusPreco.dispose();
    _focusDescription.dispose();
    _focusImageUrl.removeListener(updateImageUrl);
    _focusImageUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Informe um titulo válido';
                  }

                  if (value.trim().length <= 3) {
                    return 'Informe um titulo com no minimo 3 letras';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_focusPreco);
                },
                onSaved: (value) => _formData['title'] = value,
              ),
              TextFormField(
                focusNode: _focusPreco,
                validator: (value) {
                  var newPrice = double.tryParse(value);

                  if (value.trim().isEmpty) {
                    return 'Informe um preço válido';
                  }

                  if (newPrice == null || newPrice <= 0) {
                    return 'Informe um preço válido';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Preço',
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_focusDescription);
                },
                onSaved: (value) => _formData['price'] = double.parse(value),
              ),
              TextFormField(
                focusNode: _focusDescription,
                validator: (value) {
                  if (value.trim().length <= 3) {
                    return 'Informe uma descrição valida';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Descrição',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value) => _formData['description'] = value,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _focusImageUrl,
                      controller: _imageUrlController,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Informe uma url valida';
                        }

                        if (!_isValidImageUrl(value)) {
                          return 'Informe uma url valida';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'URL da Imagem',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) => _formData['imageUrl'] = value,
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a url')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
