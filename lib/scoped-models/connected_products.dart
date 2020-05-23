import 'package:helloworld/models/product.dart';
import 'package:helloworld/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;
  bool _isLoading = false;

  Future<Null> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://i1.wp.com/www.eatthis.com/wp-content/uploads/2017/10/dark-chocolate-bar-squares.jpg?fit=1024%2C750&ssl=1',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userID': _authenticatedUser.id
    };

    return http
        .post('https://flutter-products-480c3.firebaseio.com/products.json',
            body: json.encode(productData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userID: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners(); //live update
    });
  }
}

class ProductsModel extends ConnectedProducts {
  bool _showFavs = false;

  List<Product> get allProducts {
    return List.from(_products); //sends a copy of _products
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (_selProductIndex == null) {
      return null;
    }
    return _products[_selProductIndex];
  }

  List<Product> get displayedProducts {
    if (_showFavs == true) {
      return List.from(_products
          .where((Product product) => product.isFavorite == true)
          .toList()); //filter
    }
    return List.from(_products); //sends a copy of _products
  }

  bool get displayFavsOnly {
    return _showFavs;
  }

  void deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    notifyListeners();
    http
        .delete(
            'https://flutter-products-480c3.firebaseio.com/products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;
      
      notifyListeners(); //live update
    });
  }

  Future<Null> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://i1.wp.com/www.eatthis.com/wp-content/uploads/2017/10/dark-chocolate-bar-squares.jpg?fit=1024%2C750&ssl=1',
      'userEmail': _authenticatedUser.email,
      'userID': _authenticatedUser.id
    };
    return http
        .put(
            'https://flutter-products-480c3.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updatedData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userID: selectedProduct.userID);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners(); //live update
    });
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners(); //live update
  }

  void fetchProduct() {
    _isLoading = true;
    notifyListeners();
    http
        .get('https://flutter-products-480c3.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];

      print("Anushkaaaaa");
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productID, dynamic productData) {
        final Product product = Product(
          id: productID,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'],
          userEmail: productData['userEmail'],
          userID: productData['userID'],
        );
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleProductFavStatus() {
    final bool isCurrentlyFav = selectedProduct.isFavorite;
    final bool newFavStatus = !isCurrentlyFav;
    final Product updateProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userID: selectedProduct.userID,
        isFavorite: newFavStatus);
    _products[selectedProductIndex] = updateProduct;
    print('status toggled of ' + updateProduct.title);
    notifyListeners(); //live update
  }

  void toggleDisplayMode() {
    _showFavs = !_showFavs;
    print(_showFavs);
    notifyListeners(); //live update
  }
}

class UserModel extends ConnectedProducts {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'Anussa', email: email, password: password);
  }
}

class UtilityModel extends ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
