import '../../models/product_model.dart';

class FavoritesState {
  final List<Product> favorites;

  const FavoritesState({required this.favorites});

  factory FavoritesState.fromJson(Map<String, dynamic> json) {
    return FavoritesState(
      favorites: (json['favorites'] as List)
          .map((item) => Product.fromJson(item)) // Assuming Product has fromJson method
          .toList(),
      );
  }

  //Method to convert FavoritesState to JSON (for HydratedBloc)
  Map<String, dynamic> toJson() {
    return {
      'favorites': favorites.map((product) => product.toJson()).toList(),
    };
  }

  FavoritesState copyWith({List<Product>? favorites}) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
    );
  }
}
