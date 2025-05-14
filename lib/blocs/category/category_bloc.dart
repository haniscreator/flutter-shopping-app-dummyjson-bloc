import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../../models/category_model.dart';
import '../../../repositories/category_repository.dart';

class CategoryBloc extends HydratedBloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryState.initial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategoryEvent>(_onSelectCategory); // Don't forget this!
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final categories = await repository.fetchCategories();
      final allCategory = Category(slug: 'All', name: 'All', url: '');
      final updatedCategories = [allCategory, ...categories];

      emit(state.copyWith(
        categories: updatedCategories,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load categories',
      ));
    }
  }

  void _onSelectCategory(
      SelectCategoryEvent event, Emitter<CategoryState> emit) {
    emit(state.copyWith(selectedCategory: event.selectedCategory));
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) {
    try {
      return CategoryState(
        categories: (json['categories'] as List)
            .map((e) => Category.fromJson(e))
            .toList(),
        selectedCategory: json['selectedCategory'] ?? 'All',
        isLoading: false,
        error: null,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CategoryState state) {
    return {
      'categories': state.categories.map((e) => e.toJson()).toList(),
      'selectedCategory': state.selectedCategory,
    };
  }
}

