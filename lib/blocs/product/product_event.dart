abstract class ProductEvent {}

class LoadInitialProducts extends ProductEvent {}

class LoadMoreProducts extends ProductEvent {}

class SearchQueryChanged extends ProductEvent {
  final String query;

  SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

//class LoadCategories extends ProductEvent {}

class LoadProductsByCategory extends ProductEvent {
  final String category;

  LoadProductsByCategory({required this.category});
}

