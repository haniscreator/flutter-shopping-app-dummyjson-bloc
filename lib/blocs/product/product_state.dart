import '../../../../models/product_model.dart';


class ProductState {
  final List<Product> products;
  final bool hasReachedEnd;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const ProductState({
    required this.products,
    required this.hasReachedEnd,
    required this.isLoading,
    required this.isLoadingMore,
    this.error,
  });

  factory ProductState.initial() {
    return const ProductState(
      products: [],
      hasReachedEnd: false,
      isLoading: false,
      isLoadingMore: false,
      error: null,
    );
  }

  ProductState copyWith({
    List<Product>? products,
    bool? hasReachedEnd,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
    );
  }

  factory ProductState.fromMap(Map<String, dynamic> map) {
    return ProductState(
      products: (map['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
      hasReachedEnd: map['hasReachedEnd'] ?? false,
      isLoading: map['isLoading'] ?? false,
      isLoadingMore: map['isLoadingMore'] ?? false,
      error: map['error'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((e) => e.toJson()).toList(),
      'hasReachedEnd': hasReachedEnd,
      'isLoading': isLoading,
      'isLoadingMore': isLoadingMore,
      'error': error,
    };
  }

  @override
  String toString() {
    return 'ProductState(products: ${products.length}, hasReachedEnd: $hasReachedEnd, isLoading: $isLoading, isLoadingMore: $isLoadingMore, error: $error)';
  }
}
