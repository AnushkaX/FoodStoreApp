import 'package:helloworld/scoped-models/connected_products.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with ConnectedProducts, UserModel, ProductsModel, UtilityModel  {

}