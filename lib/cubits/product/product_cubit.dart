import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/services/product_services.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState());

  // Called when there is no internet connection
  showNoConnectionMessage() {
    emit(const ProductState(
        status: ProductStatus.error,
        message: 'No Internet Connection!\nConnect to the internet'));
  }

  // Gets all products from Firestore database
  Future<void> fetchProducts() async {
    try {
      emit(const ProductState());
      List<Product> products = await ProductServices().fetchProducts();
      emit(ProductState(status: ProductStatus.success, products: products));
    } on SocketException {
      emit(const ProductState(
        status: ProductStatus.error,
        message: 'No Internet Connection!\nConnect to the internet',
      ));
    } catch (error) {
      emit(const ProductState(
          status: ProductStatus.error, message: 'Some error occurred'));
    }
  }

  // Filter products based on selected brand
  Future<void> filterProducts(String brand) async {
    if (brand == 'All') {
      emit(state.copyWith(filteredProducts: []));
    } else {
      var filteredProducts = state.products
          .where((e) => e.brand?.toLowerCase() == brand.toLowerCase())
          .toList();
      emit(state.copyWith(filteredProducts: filteredProducts));
    }
  }

  // Add product to Favorites
  void addToFavorites(String id) {
    final List<Product> products = state.products.map((e) {
      if (e.id == id) {
        e.isFavorite = true;
      }
      return e;
    }).toList();
    emit(state.copyWith(products: products));
  }

  // Remove product from Favorites
  void removeFromFavorites(String id) {
    final List<Product> products = state.products.map((e) {
      if (e.id == id) {
        e.isFavorite = false;
      }
      return e;
    }).toList();
    emit(state.copyWith(products: products));
  }

  // Add product to cart
  void addToCart(Product product) {
    List<Product> cartProducts = [...state.cartProducts, product];
    emit(state.copyWith(cartProducts: cartProducts));
  }

  // Called when product quantity is incremented in Cart Screen
  void increaseQuantity(String id) {
    final List<Product> cartProducts = state.cartProducts.map((e) {
      if (e.id == id) {
        e.quantity++;
      }
      return e;
    }).toList();
    emit(state.copyWith(cartProducts: cartProducts));
  }

  // Called when product quantity is decremented in Cart Screen
  void decreaseQuantity(String id) {
    final List<Product> cartProducts = state.cartProducts.map((e) {
      if (e.id == id) {
        e.quantity--;
      }
      return e;
    }).toList();
    emit(state.copyWith(cartProducts: cartProducts));
  }

  // Remove item from cart
  void removeFromCart(String id) {
    List<Product> products = state.products.map((e) {
      if (e.id == id) {
        e.addedToCart = false;
        e.quantity = 1;
      }
      return e;
    }).toList();
    List<Product> cartProducts =
        state.cartProducts.where((e) => e.id != id).toList();
    emit(state.copyWith(products: products, cartProducts: cartProducts));
  }

  // Clears all items from the cart
  // Called when an order is stored to the database
  void clearCartItems() {
    final List<Product> products = state.products.map((e) {
      e.quantity = 1;
      e.addedToCart = false;
      return e;
    }).toList();
    emit(state.copyWith(products: products, cartProducts: []));
  }
}
