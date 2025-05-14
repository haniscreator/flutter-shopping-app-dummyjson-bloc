import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../../models/category_model.dart';
import '../../../repositories/product_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryState.initial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final categories = await repository.fetchCategories();

      // Add "All" category manually at the top
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
}
