import '../../../../models/product_model.dart';
import '../../../../models/category_model.dart';

class ProductState {
  final List<Product> products;
  final bool hasReachedEnd;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  final List<Category> categories;
  final String? selectedCategory;

  const ProductState({
    required this.products,
    required this.hasReachedEnd,
    required this.isLoading,
    required this.isLoadingMore,
    this.error,
    required this.categories,
    this.selectedCategory,
  });

  factory ProductState.initial() {
    return const ProductState(
      products: [],
      hasReachedEnd: false,
      isLoading: false,
      isLoadingMore: false,
      error: null,
      categories: [],
      selectedCategory: null,
    );
  }

  ProductState copyWith({
    List<Product>? products,
    bool? hasReachedEnd,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    List<Category>? categories,
    String? selectedCategory,
  }) {
    return ProductState(
      products: products ?? this.products,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
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
      categories: (map['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e))
          .toList(),
      selectedCategory: map['selectedCategory'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((e) => e.toJson()).toList(),
      'hasReachedEnd': hasReachedEnd,
      'isLoading': isLoading,
      'isLoadingMore': isLoadingMore,
      'error': error,
      'categories': categories.map((e) => e.toJson()).toList(),
      'selectedCategory': selectedCategory,
    };
  }

  @override
  String toString() {
    return 'ProductState(products: ${products.length}, hasReachedEnd: $hasReachedEnd, isLoading: $isLoading, isLoadingMore: $isLoadingMore, error: $error, categories: ${categories.length}, selectedCategory: $selectedCategory)';
  }
}
