import 'package:flutter/material.dart';
import './product_create.dart';
import './product_list.dart';

//Manage Products page

class ProductsAdminManager extends StatelessWidget {
  

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      //slider
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading:
                false, //make dissappear the hamburger icon
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //tabs
      length: 2,
      child: Scaffold(
        //Creates the page
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text("Manage Products"),
          bottom: TabBar(
            //tab
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              )
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          ProductCreatePage(),
          ProductListPage(),
        ]),
      ),
    );
  }
}
