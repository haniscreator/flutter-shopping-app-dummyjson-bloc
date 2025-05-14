import '../../../models/category_model.dart';

class CategoryState {
  final List<Category> categories;
  final String selectedCategory;
  final bool isLoading;
  final String? error;

  const CategoryState({
    this.categories = const [],
    this.selectedCategory = 'All',
    this.isLoading = false,
    this.error,
  });

  CategoryState copyWith({
    List<Category>? categories,
    String? selectedCategory,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  static CategoryState initial() {
    return const CategoryState();
  }
}



