import 'package:flutter/material.dart';
import './product_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products) {
    print("[Product Widget] Constructor");
  }

  Widget _buildProductList() {
    return products.length > 0
        ? ListView.builder(
            //if
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(products[index], index),
            itemCount: products.length,
          )
        : Center(child: Text("No products! Please add")); //else
  }

  Widget build(BuildContext context) {
    print("[Product Widget] Build");
    return _buildProductList();
  }
}
