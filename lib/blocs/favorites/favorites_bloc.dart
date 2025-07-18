import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';



class FavoritesBloc extends HydratedBloc<FavoritesEvent, FavoritesState> {
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


// HydratedBloc overrides for caching
@override
FavoritesState? fromJson(Map<String, dynamic> json) {
  try{
    return FavoritesState.fromJson(json);
  } catch (_) {
    return null;
  }
}

@override
Map<String, dynamic>? toJson(FavoritesState state) {
  return state.toJson();
}

}
