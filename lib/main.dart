import 'package:flutter/material.dart';
import 'package:helloworld/pages/auth.dart';
import 'package:helloworld/pages/product.dart';
import 'package:helloworld/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
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
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),       //^creates the instance and pass down to every class
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            accentColor: Colors.grey,
            buttonColor: Colors.black,
            fontFamily: 'Tekton'),
        home: AuthPage(), //'/' is a reserved name for home.
        routes: {
          //'/': (BuildContext context) => ProductsPage(_products),
          '/products': (BuildContext context) => ProductsPage(), //Products page
          '/admin': (BuildContext context) =>
              ProductsAdminManager(), //manage products page
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
              builder: (BuildContext context) =>
                  ProductPage(index),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage());
        },
      ),
    );
  }
}
