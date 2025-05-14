import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../../models/product_model.dart';
import '../../../repositories/product_repository.dart';
import '../../../repositories/category_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';



class ProductBloc extends HydratedBloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  final CategoryRepository catRepository;
  final int _limit = 6;
  List<Product> _allProducts = [];
  String _searchQuery = '';

  ProductBloc(this.repository, this.catRepository) : super(ProductState.initial()) {
    on<LoadInitialProducts>(_onLoadInitialProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    //on<LoadCategories>(_onLoadCategories);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
  }

  Future<void> _onLoadInitialProducts(
    LoadInitialProducts event, Emitter<ProductState> emit) async {
    
    emit(state.copyWith(isLoading: true, error: null));

    if (!await isOnline()) {
      if (state.products.isNotEmpty) {
        emit(state.copyWith(
          isLoading: false,
          error: 'No internet. Showing cached data.',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'No internet connection.',
        ));
      }
      return;
    }

    try {
      final products = await repository.fetchProducts(limit: _limit, skip: 0);
      _allProducts = products;
      emit(state.copyWith(
        products: products,
        hasReachedEnd: products.length < _limit,
        isLoading: false,
      ));
    } catch (e) {
      if (state.products.isNotEmpty) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to update. Showing cached products.',
        ));
      } else {
        emit(state.copyWith(
          products: [],
          isLoading: false,
          error: 'Failed to load products.',
        ));
      }
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

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<ProductState> emit) async {
    _searchQuery = event.query.trim();

    if (_searchQuery.isEmpty) {
      // Reload initial products if search cleared
      add(LoadInitialProducts());
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final searchedProducts = await repository.searchProducts(_searchQuery);

      emit(state.copyWith(
        products: searchedProducts,
        isLoading: false,
        hasReachedEnd: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to search products',
      ));
    }
  }


  Future<void> _onLoadProductsByCategory(
      LoadProductsByCategory event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoading: true, selectedCategory: event.category));

    try {
      final products = await catRepository.fetchProductsByCategory(event.category);
      emit(state.copyWith(
        products: products,
        isLoading: false,
        hasReachedEnd: true,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
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

  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}