import '../../models/product_model.dart';

class FavoritesState {
  final List<Product> favorites;

  const FavoritesState({required this.favorites});

  FavoritesState copyWith({List<Product>? favorites}) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
    );
  }
}
