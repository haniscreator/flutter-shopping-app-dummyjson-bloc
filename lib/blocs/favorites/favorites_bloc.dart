import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product_model.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import 'package:fakestoreapi_app/models/product_model.dart';



class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState(favorites: [])) {
    on<ToggleFavoriteEvent>((event, emit) {
      final isFavorited = state.favorites.any((p) => p.id == event.product.id);
      if (isFavorited) {
        emit(FavoritesState(
          favorites: state.favorites.where((p) => p.id != event.product.id).toList(),
        ));
      } else {
        emit(FavoritesState(
          favorites: [...state.favorites, event.product],
        ));
      }
    });
  }
}
