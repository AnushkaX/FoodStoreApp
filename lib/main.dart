import 'package:flutter/material.dart';
import 'package:helloworld/pages/auth.dart';
import 'package:helloworld/pages/product.dart';
import 'pages/products.dart';
import 'pages/products_admin.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _updateProduct(int index, Map<String, dynamic> product) {
    setState(() {
      _products[index] = product;
    });

  }

  Widget build(context) {
    var materialApp = MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
          accentColor: Colors.grey,
          buttonColor: Colors.black,
          fontFamily: 'Tekton'),
      home: AuthPage(),               //'/' is a reserved name for home.
      routes: {
        //'/': (BuildContext context) => ProductsPage(_products),
        '/products' : (BuildContext context) => ProductsPage(_products),     //Products page
        '/admin': (BuildContext context) => 
            ProductsAdminManager(_addProduct,_updateProduct, _deleteProduct, _products),              //manage products page
        //setting route names
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }

        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);

          return MaterialPageRoute<bool>(
            //how you navigate to a page
            builder: (BuildContext context) => ProductPage(
                _products[index]['title'], _products[index]['image'], _products[index]['description'], _products[index]['price']),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_products));
      },
    );
    return materialApp;
  }
}
