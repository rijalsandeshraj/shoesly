import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly/models/select_option.dart';

// ignore: must_be_immutable
class Product {
  String id;
  String name;
  String description;
  String brand;
  String brandLogoUrl;
  String imageUrl;
  List<num> sizes;
  List<String> hexColors;
  num price;
  num averageRating;
  int reviewsCount;
  String addedDate;
  List<String> gender;
  bool addedToCart;
  bool isFavorite;
  int quantity;
  num? selectedSize;
  SelectOption? selectedColor;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.brandLogoUrl,
    required this.imageUrl,
    required this.sizes,
    required this.hexColors,
    required this.price,
    required this.averageRating,
    required this.reviewsCount,
    required this.addedDate,
    required this.gender,
    this.addedToCart = false,
    this.isFavorite = false,
    this.quantity = 1,
  });

  // Map product fetched from Firestore to Product
  factory Product.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final docId = document.id;
    final data = document.data() ?? {};
    return Product(
      id: docId,
      name: data['name'] ?? 'N/A',
      description: data['description'] ?? 'N/A',
      brand: data['brand'] ?? 'N/A',
      brandLogoUrl: data['brandLogoUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      sizes: (data['sizes'] ?? []).cast<num>(),
      hexColors: (data['hexColors'] ?? []).cast<String>(),
      price: data['price'] ?? 0,
      averageRating: data['averageRating'] ?? 0,
      reviewsCount: data['reviewsCount'] ?? 0,
      addedDate: data['addedDate'] ?? 'N/A',
      gender: (data['gender'] ?? []).cast<String>(),
    );
  }

  // Method called for seeding products data to database
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

  // Method called for creating products data for placing orders
  Map<String, dynamic> toJsonForOrder(double totalPrice) => {
        'name': name,
        'brand': brand,
        'selectedColor': selectedColor?.title ?? 'Color N/A',
        'selectedSize': selectedSize,
        'price': price,
        'quantity': quantity,
        'totalPrice': totalPrice,
      };
}
