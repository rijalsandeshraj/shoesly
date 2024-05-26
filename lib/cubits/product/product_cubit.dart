import 'dart:io';
import 'package:equatable/equatable.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/services/product_services.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(FirebaseStorage firebaseStorage) : super(ProductState());

  // Called when there is no internet connection
  showNoConnectionMessage() {
    emit(ProductState(
        status: ProductStatus.error,
        message: 'No Internet Connection!\nConnect to the internet'));
  }

  // Gets all products from Firestore database
  Future<void> fetchProducts() async {
    try {
      emit(ProductState());
      List<Product> products = await ProductServices().fetchProducts();
      emit(ProductState(status: ProductStatus.success, products: products));
    } on SocketException {
      emit(ProductState(
        status: ProductStatus.error,
        message: 'No Internet Connection!\nConnect to the internet',
      ));
    } catch (error) {
      emit(ProductState(
          status: ProductStatus.error, message: 'Some error occurred'));
    }
  }

  // Filter products based on selected brand
  Future<void> filterProducts(String brand) async {
    if (brand == 'All') {
      emit(ProductState(
          status: ProductStatus.success, products: state.products));
    } else {
      var filteredProducts = state.products!
          .where((e) => e.brand?.toLowerCase() == brand.toLowerCase())
          .toList();
      emit(state.copyWith(
          status: ProductStatus.success, filteredProducts: filteredProducts));
    }
  }

  // Add product to cart
  void addToCart(Product product) {
    state.cartProducts ??= [];
    state.cartProducts!.add(product);
    emit(state);
  }

  // Called when product quantity is incremented in Cart Screen
  void increaseQuantity(String id) {
    state.cartProducts!.firstWhere((e) => e.id == id).quantity++;
    emit(state);
  }

  // Called when product quantity is decremented in Cart Screen
  void decreaseQuantity(String id) {
    // state.products.firstWhere((e) => e.id == id).quantity--;
    int quantity = state.cartProducts!.firstWhere((e) => e.id == id).quantity;
    final List<Product> cartProducts = state.cartProducts!.map((element) {
      if (element.id == id) {
        element.quantity = quantity - 1;
      }
      return element;
    }).toList();
    emit(state.copyWith(cartProducts: cartProducts));
  }

  // Gets all cart products
  get getCartProducts {
    if (state.status == ProductStatus.success) {
      List<Product> cartProducts =
          state.products!.where((element) => element.addedToCart).toList();
      return cartProducts;
    }
    return <Product>[];
  }

  // Returns total price of products added to cart
  double get getTotalPrice {
    double totalPrice = 0;
    List<Product> cartProducts = state.cartProducts!;

    for (var element in cartProducts) {
      totalPrice += element.quantity * (element.price ?? 0);
    }

    return totalPrice;
  }
}
