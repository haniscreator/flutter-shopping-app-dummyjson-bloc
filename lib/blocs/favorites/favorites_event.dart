import '../../models/product_model.dart';


abstract class FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final Product product;

  ToggleFavoriteEvent({required this.product});
}
