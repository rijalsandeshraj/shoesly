part of 'product_cubit.dart';

enum ProductStatus {
  loading,
  success,
  error,
}

class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStatus.loading,
    this.products,
    this.message,
  });

  final ProductStatus status;
  final List<ProductModel>? products;
  // The info or error message to be displayed as a snackbar
  final String? message;

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    String? message,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
    );
  }

  @override
  List<dynamic> get props => [status, products, message];
}
