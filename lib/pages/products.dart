import 'package:flutter/material.dart';
import 'package:helloworld/scoped-models/main.dart';
import 'package:helloworld/widgets/products/products.dart';
import 'package:scoped_model/scoped_model.dart';

//Home Page

class ProductsPage extends StatelessWidget {
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
          ScopedModelDescendant<MainModel>(builder:
              (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.displayFavsOnly ? Icons.favorite : Icons.favorite_border), //fav button
              onPressed: () {
                model.toggleDisplayMode();
              },
              color: Colors.red,
            );
          })
        ],
      ),
      body: Products(),
    );
  }
}
