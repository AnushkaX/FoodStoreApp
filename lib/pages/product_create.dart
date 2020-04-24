import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatPageState();
  }
}

class _ProductCreatPageState extends State<ProductCreatePage> {
  String _titleValue = '';
  String _descriptionValue = '';
  double _priceValue;

  Widget _buildTitleTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Product Title",
      ),
      onChanged: (String value) {
        setState(() {
          _titleValue = value;
        });
      },
    );
  }

  Widget _buildTitleDescriptionField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Product Description",
      ),
      maxLines: 4,
      onChanged: (String value) {
        setState(() {
          _descriptionValue = value;
        });
      },
    );
  }

  Widget _buildTitlePriceField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Product Price",
      ),
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        setState(() {
          _priceValue = double.parse(value);
        });
      },
    );
  }

  void _submitForm() {
    final Map<String, dynamic> product = {
      'title': _titleValue,
      'description': _descriptionValue,
      'price': _priceValue,
      'image': 'assets/img.JPG',
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        //Scrollable
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
        ],
      ),
    );
  }
}


