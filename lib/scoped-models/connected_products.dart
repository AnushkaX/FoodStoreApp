import 'package:helloworld/models/product.dart';
import 'package:helloworld/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;

  Future<bool> addProduct(
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
        .then((http.Response response) {          //can use async code also 
          if(response.statusCode != 200 && response.statusCode != 201) {
            _isLoading = false;
            notifyListeners();
            return false;
          }
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
      return true;
    }).catchError((error) {
      _isLoading = false;
            notifyListeners();
            return false;
    });
  }
}

class ProductsModel extends ConnectedProducts {
  bool _showFavs = false;

  List<Product> get allProducts {
    return List.from(_products); //sends a copy of _products
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product){
      return product.id == _selProductId;
    });
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

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
            return product.id == _selProductId;
          });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-products-480c3.firebaseio.com/products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners(); //live update
      return true;
    }).catchError((error) {
      _isLoading = false;
            notifyListeners();
            return false;
    });
  }

  Future<bool> updateProduct(
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
          final int selectedProductIndex = _products.indexWhere((Product product) {
            return product.id == _selProductId;
          });
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners(); //live update
      return true;
    }).catchError((error) {
      _isLoading = false;
            notifyListeners();
            return false;
    });
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners(); //live update
  }

  Future<Null> fetchProduct() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutter-products-480c3.firebaseio.com/products.json')
        .then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
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
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
            notifyListeners();
            return false;
    });
  }

  void toggleProductFavStatus() {
    final bool isCurrentlyFav = selectedProduct.isFavorite;
    final bool newFavStatus = !isCurrentlyFav;
    final Product updateProduct = Product(
        id: selectedProduct.id,
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
