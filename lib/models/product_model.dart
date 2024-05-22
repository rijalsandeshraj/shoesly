import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
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
  bool? brandLogoLoaded;
  bool? imageLoaded;

  ProductModel({
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
    this.brandLogoLoaded,
    this.imageLoaded,
  });

  // Map product fetched from Firestore to ProductModel
  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final docId = document.id;
    final data = document.data()!;
    return ProductModel(
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
}
