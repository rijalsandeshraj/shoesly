import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly/models/product_model.dart';

class ProductServices {
  // Creating a private constructor
  ProductServices._privateConstructor();
  // Creating a single instance of the class
  static final ProductServices _instance =
      ProductServices._privateConstructor();
  factory ProductServices() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final productsRef =
      FirebaseFirestore.instance.collection('firestore-example-app');
  // .withConverter<ProductModel>(
  //   fromFirestore: (snapshots, _) => ProductModel.fromJson(snapshots.data()!),
  //   toFirestore: (movie, _) => movie.toJson(),
  // );

  Future<List<ProductModel>> fetchProducts() async =>
      _firestore.collection('products').get().then((result) {
        // List<ProductModel> products = [];
        // for (var product in result.docs) {
        //   products.add(ProductModel.fromSnapshot(result.docs));
        // }
        List<ProductModel> products =
            result.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
        return products;
      });

  // Future<List<ProductModel>> searchProducts({String productName}) {
  //   // code to convert the first character to uppercase
  //   String searchKey = productName[0].toUpperCase() + productName.substring(1);
  //   return _firestore
  //       .collection('products')
  //       .orderBy("name")
  //       .startAt([searchKey])
  //       .endAt(['$searchKey\uf8ff'])
  //       .getDocuments()
  //       .then((result) {
  //         List<ProductModel> products = [];
  //         for (DocumentSnapshot product in result.documents) {
  //           products.add(ProductModel.fromSnapshot(product));
  //         }
  //         return products;
  //       });
  // }
}
