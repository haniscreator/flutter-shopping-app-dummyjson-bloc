import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../../models/product_model.dart';
import '../../../repositories/product_repository.dart';

class ProductBloc extends HydratedBloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  final int _limit = 6;

  ProductBloc(this.repository) : super(ProductState.initial()) {
    on<LoadInitialProducts>(_onLoadInitialProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }

  Future<void> _onLoadInitialProducts(
      LoadInitialProducts event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final products = await repository.fetchProducts(limit: _limit, skip: 0);
      emit(state.copyWith(
        products: products,
        hasReachedEnd: products.length < _limit,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        products: [],
        isLoading: false,
        error: 'Failed to load products',
      ));
    }
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event, Emitter<ProductState> emit) async {
    if (state.hasReachedEnd || state.isLoadingMore) return;

    try {
      emit(state.copyWith(isLoadingMore: true));
      final newProducts = await repository.fetchProducts(
        limit: _limit,
        skip: state.products.length,
      );

      final allProducts = List<Product>.from(state.products)
        ..addAll(newProducts);

      emit(state.copyWith(
        products: allProducts,
        hasReachedEnd: newProducts.length < _limit,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        error: 'Failed to load more products',
      ));
    }
  }

  // For HydratedBloc
  @override
  ProductState? fromJson(Map<String, dynamic> json) {
    try {
      return ProductState.fromMap(json);
    } catch (_) {
      return ProductState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(ProductState state) {
    return state.toMap();
  }
}