import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:shoesly/common/app_variables.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/models/review.dart';
import 'package:shoesly/models/select.dart';

import '../models/order.dart';

class ProductServices {
  // Creating a private constructor
  ProductServices._privateConstructor();
  // Creating a single instance of the class
  static final ProductServices _instance =
      ProductServices._privateConstructor();

  factory ProductServices() {
    return _instance;
  }

  final _productsRef = FirebaseFirestore.instance.collection('products');
  final _ordersRef = FirebaseFirestore.instance.collection('orders');

  // Adds brands to common list based on products fetched from Firestore database
  addToBrandList(List<Product> products) {
    List<SelectOption> brands = [SelectOption(id: 0, title: 'All')];
    int id = 1;
    for (var product in products) {
      bool notInList = brands.any((e) => e.title != product.brand);
      if (notInList) {
        brands.add(SelectOption(
          id: id,
          title: product.brand ?? 'N/A',
          value: product.brandLogoUrl,
        ));
        id++;
      }
    }
    AppVariables.brands.value = brands;
  }

  Future<List<Product>> fetchProducts() async {
    final result = await _productsRef.get();
    List<Product> products =
        result.docs.map((e) => Product.fromSnapshot(e)).toList();
    addToBrandList(products);
    return products;
  }

  Future<List<Review>> getReviews(String productId) async {
    final result =
        await _productsRef.doc(productId).collection('reviews').get();
    final reviews =
        result.docs.map((doc) => Review.fromJson({...doc.data()})).toList();
    return reviews;
  }

  // Called for storing order to Firestore database
  Future<void> addOrderToFirestore(Order order) async {
    await _ordersRef.add(order.toJson());
  }

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

  // Called once
  // Initially called for seeding data to Firestore database
  Future<void> addProductsToFirestore(List<Product> products) async {
    for (var product in products) {
      // Add the product data to the collection
      await _productsRef.add(product.toJson());
      // print('Product added successfully!');
    }
  }
}
