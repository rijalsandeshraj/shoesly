import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly/models/select.dart';

class Product {
  String? id;
  String? name;
  String? description;
  String? brand;
  String? brandLogoUrl;
  String? imageUrl;
  List<num>? sizes;
  List<String>? hexColors;
  num? price;
  num? averageRating;
  int? reviewsCount;
  String? addedDate;
  List<String>? gender;
  bool addedToCart;
  bool isFavorite;
  int quantity;
  num? selectedSize;
  SelectOption? selectedColor;

  Product({
    this.id,
    this.name,
    this.description,
    this.brand,
    this.brandLogoUrl,
    this.imageUrl,
    this.sizes,
    this.hexColors,
    this.price,
    this.averageRating,
    this.reviewsCount,
    this.addedDate,
    this.gender,
    this.addedToCart = false,
    this.isFavorite = false,
    this.quantity = 1,
  });

  // Map product fetched from Firestore to Product
  factory Product.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final docId = document.id;
    final data = document.data()!;
    return Product(
      id: docId,
      name: data['name'],
      description: data['description'],
      brand: data['brand'],
      brandLogoUrl: data['brandLogoUrl'],
      imageUrl: data['imageUrl'],
      sizes: (data['sizes'] as List).cast<num>(),
      hexColors: (data['hexColors'] as List).cast<String>(),
      price: data['price'],
      averageRating: data['averageRating'],
      reviewsCount: data['reviewsCount'],
      addedDate: data['addedDate'],
      gender: (data['gender'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'brand': brand,
        'brandLogoUrl': brandLogoUrl,
        'imageUrl': imageUrl,
        'sizes': sizes,
        'hexColors': hexColors,
        'price': price,
        'averageRating': averageRating,
        'reviewsCount': reviewsCount,
        'addedDate': addedDate,
        'gender': gender,
      };
}
