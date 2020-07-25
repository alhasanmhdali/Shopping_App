import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../providers/cart.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _urlController = TextEditingController();

  var _titleValidate = false;
  var _priceValidate = false;
  var _descValidate = false;
  var _imageValidate = false;
  int _validImage = 0;

  String title = 'Add New Product';

  Widget _imagePreview = Image.asset('assets/images/no-image.png');

  void _validateTitle() {
    if (!_titleValidate) {
      setState(() {
        _titleValidate = true;
      });
    }
  }

  void _validatePrice() {
    if (!_priceValidate) {
      setState(() {
        _priceValidate = true;
      });
    }
  }

  void _validateDesc() {
    if (!_descValidate) {
      setState(() {
        _descValidate = true;
      });
    }
  }

  void _validateUrl() {
    if (!_imageValidate) {
      setState(() {
        _imageValidate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Product prod = ModalRoute.of(context).settings.arguments;
    if (prod != null) {
      _initialProduct = prod;
      title = 'Edit: ${_initialProduct.title}';
      _validImage = 1;
    }
    _urlController.text = _initialProduct.imageUrl;
    _urlController.addListener(_updateImage);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageFocusNode.dispose();
    _urlController.removeListener(_updateImage);
    _urlController.dispose();
    super.dispose();
  }

  var _initialProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  String _imageValidator(value) {
    if (value.isEmpty) return 'This field is important';
    if (!value.startsWith('http')) return 'Please enter a valid url';
    if (!value.endsWith('.png') &&
        !value.endsWith('.jpg') &&
        !value.endsWith('.jpeg')) return 'Please enter a valid image url';
    _validImage = 1;
    return null;
  }

  void _updateImage() {
    setState(() {
      _validImage = 0;
      _validateUrl();
      final String val = _urlController.text;
      _imageValidator(val);
      _imagePreview = _validImage != 1
          ? Image.asset('assets/images/no-image.png')
          : Image.network(val);
    });
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    if (_initialProduct.id == null)
      Provider.of<ProductsProvider>(context, listen: false).addProduct(Product(
          id: DateTime.now().toString(),
          title: _initialProduct.title,
          price: _initialProduct.price,
          description: _initialProduct.description,
          imageUrl: _initialProduct.imageUrl));
    else {
      Provider.of<ProductsProvider>(context, listen: false).editProduct(Product(
          id: _initialProduct.id,
          title: _initialProduct.title,
          price: _initialProduct.price,
          description: _initialProduct.description,
          imageUrl: _initialProduct.imageUrl));
      Provider.of<Cart>(context, listen: false).updateProduct(Product(
          id: _initialProduct.id,
          title: _initialProduct.title,
          price: _initialProduct.price,
          description: _initialProduct.description,
          imageUrl: _initialProduct.imageUrl));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //...........Title form field...........
                TextFormField(
                  focusNode: _titleFocusNode,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Title:',
                  ),
                  initialValue: _initialProduct.title,
                  autovalidate: _titleValidate,
                  validator: (value) {
                    if (value.isEmpty) return 'This field is important';
                    if (value.length < 4)
                      return 'Enter a name with more that 3 chars';
                    return null;
                  },
                  onSaved: (value) {
                    _initialProduct = Product(
                      id: _initialProduct.id,
                      title: value,
                      price: _initialProduct.price,
                      description: _initialProduct.description,
                      imageUrl: _initialProduct.imageUrl,
                    );
                  },
                  onFieldSubmitted: (value) {
                    _priceFocusNode.requestFocus();
                    _validateTitle();
                  },
                  onChanged: (_) => _validateTitle(),
                ),
                const SizedBox(height: 20),
                //...........Price form field...........
                TextFormField(
                  focusNode: _priceFocusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Price:',
                  ),
                  initialValue: _initialProduct.price == 0
                      ? null
                      : _initialProduct.price.toString(),
                  autovalidate: _priceValidate,
                  validator: (value) {
                    if (value.isEmpty) return 'This field is important';
                    if (double.tryParse(value) == null)
                      return 'Please inter a valid number!';
                    if (double.parse(value) <= 0)
                      return 'Please enter a number greater than 0';
                    return null;
                  },
                  onSaved: (value) {
                    _initialProduct = Product(
                      id: _initialProduct.id,
                      title: _initialProduct.title,
                      price: double.parse(value),
                      description: _initialProduct.description,
                      imageUrl: _initialProduct.imageUrl,
                    );
                  },
                  onFieldSubmitted: (value) {
                    _validatePrice();
                    _descFocusNode.requestFocus();
                  },
                  onChanged: (_) => _validatePrice(),
                ),
                const SizedBox(height: 20),
                //...........Description form field...........
                TextFormField(
                  focusNode: _descFocusNode,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Description:',
                  ),
                  maxLines: 3,
                  initialValue: _initialProduct.description,
                  autovalidate: _descValidate,
                  validator: (value) {
                    if (value.isEmpty) return 'This field is important';
                    if (value.length < 10)
                      return 'Should be 10 characters long at least!';
                    return null;
                  },
                  onSaved: (value) {
                    _initialProduct = Product(
                      id: _initialProduct.id,
                      title: _initialProduct.title,
                      price: _initialProduct.price,
                      description: value,
                      imageUrl: _initialProduct.imageUrl,
                    );
                  },
                  onChanged: (_) => _validateDesc(),
                  onFieldSubmitted: (_) => _validateDesc(),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imagePreview,
                    ),
                    Expanded(
                      child: TextFormField(
                        focusNode: _imageFocusNode,
                        controller: _urlController,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Image URL:',
                        ),
//                        initialValue: _initialProduct.imageUrl,
                        autovalidate: _imageValidate,
                        validator: _imageValidator,
                        onSaved: (value) {
                          _initialProduct = Product(
                            id: _initialProduct.id,
                            title: _initialProduct.title,
                            price: _initialProduct.price,
                            description: _initialProduct.description,
                            imageUrl: value,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                RaisedButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _saveForm();
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
