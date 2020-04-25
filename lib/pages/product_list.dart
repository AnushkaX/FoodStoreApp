import 'package:flutter/material.dart';
import 'package:helloworld/pages/product_create.dart';

//Product List Tab

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;

  ProductListPage(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Image.asset(products[index]['image']),
          title: Text(products[index]['title']),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return ProductCreatePage(
                    product: products[index],
                    updateProduct: updateProduct,
                    productIndex: index,
                  );
                }),
              );
            },
          ),
        );
      },
      itemCount: products.length,
    );
  }

//Manage Products => My Products
}
