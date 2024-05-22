import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly/models/product_model.dart';
import 'package:shoesly/services/product_services.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(FirebaseStorage firebaseStorage) : super(const ProductState());

  // Called when there is no internet connection
  showNoConnectionMessage() {
    emit(const ProductState(
        status: ProductStatus.error,
        message: 'No Internet Connection!\nConnect to the internet'));
  }

  // Gets all products from Firestore database
  Future<void> fetchProducts() async {
    try {
      List<ProductModel> products = await ProductServices().fetchProducts();
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

  // Displays brand logo
  Future<void> displayBrandLogoImage(
      String documentId, String brandLogoPath) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(brandLogoPath);
      final url = await storageRef.getDownloadURL();
      state.products!.firstWhere((e) => e.id == documentId).brandLogoUrl = url;
      state.products!.firstWhere((e) => e.id == documentId).brandLogoLoaded =
          true;
      emit(ProductState(
          status: ProductStatus.success, products: state.products));
    } catch (e) {
      state.products!.firstWhere((e) => e.id == documentId).brandLogoLoaded =
          false;
      emit(ProductState(
          status: ProductStatus.success, products: state.products));
    }
  }

  // Displays product image
  Future<void> displayProductImage(String documentId, String imagePath) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(imagePath);
      final url = await storageRef.getDownloadURL();
      state.products!.firstWhere((e) => e.id == documentId).imageUrl = url;
      state.products!.firstWhere((e) => e.id == documentId).imageLoaded = true;
      emit(ProductState(
          status: ProductStatus.success, products: state.products));
    } catch (e) {
      state.products!.firstWhere((e) => e.id == documentId).imageLoaded = false;
      emit(ProductState(
          status: ProductStatus.success, products: state.products));
    }
  }
}
