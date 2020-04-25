import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;

  ProductCreatePage({this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatPageState();
  }
}

class _ProductCreatPageState extends State<ProductCreatePage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/img.JPG',
  };
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //working with forms

  Widget _buildTitleTextField() {
    return TextFormField(
      //autovalidate: true,
      validator: (String value) {
        //working with forms
        if (value.isEmpty || value.length < 5) {
          return "Title Required and should be 5 characters long!";
        }
      },
      decoration: InputDecoration(
        labelText: "Product Title",
        
      ),
      initialValue:
          widget.product == null ? "" : widget.product['title'].toString(),
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildTitleDescriptionField() {
    return TextFormField(
      validator: (String value) {
        //working with forms
        if (value.isEmpty || value.length < 10) {
          return "Description is Required and should be 10+ characters long!";
        }
      },
      decoration: InputDecoration(
        labelText: "Product Description",
      ),
      initialValue:
          widget.product == null ? "" : widget.product['description'].toString(),
      maxLines: 4,
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildTitlePriceField() {
    return TextFormField(
      validator: (String value) {
        //working with forms
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return "Price Required and should be a number!";
        }
      },
      decoration: InputDecoration(
        labelText: "Product Price",
      ),
      initialValue:
          widget.product == null ? "" : widget.product['price'].toString(),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      //working with forms
      return;
    }
    _formKey.currentState.save();
    if(widget.product == null) {
      widget.addProduct(_formData);
    }
    else {
      widget.updateProduct(widget.productIndex, _formData);
    }
    
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Widget pageContent = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey, //working with forms
          child: ListView(
            //Scrollable
            padding: EdgeInsets.symmetric(
                horizontal:
                    targetPadding / 2), //landscape portrait when list view
            children: <Widget>[
              _buildTitleTextField(),
              _buildTitleDescriptionField(),
              _buildTitlePriceField(),
              SizedBox(height: 10.0),
              RaisedButton(
                onPressed: _submitForm,
                child: Text('Save'),
                //color: Theme.of(context).accentColor,
                textColor: Colors.white,
              )

              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My Button'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );

    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: pageContent,
          );
  }
}
