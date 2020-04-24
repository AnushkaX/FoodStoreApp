import 'package:flutter/material.dart';
import 'package:helloworld/widgets/products/products.dart';

//Home Page

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductsPage(this.products);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading:
                  false, //make dissappear the hamburger icon
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            )
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Creates the page
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text("Food Store App"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.favorite), onPressed: () {}, color: Colors.red,),
        ],
      ),
      body: Products(products),
    );
  }
}
