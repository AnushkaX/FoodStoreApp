import 'package:helloworld/models/product.dart';
import 'package:helloworld/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;

  void addProduct(
      String title, String description, String image, double price) {
    final Product newProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: _authenticatedUser.email,
        userID: _authenticatedUser.id);
    _products.add(newProduct);
    notifyListeners(); //live update
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
    _products.removeAt(selectedProductIndex);
    notifyListeners(); //live update
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userID: selectedProduct.userID);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners(); //live update
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners(); //live update
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
