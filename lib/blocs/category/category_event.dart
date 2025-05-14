abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class SelectCategoryEvent extends CategoryEvent {
  final String selectedCategory;
  SelectCategoryEvent(this.selectedCategory);
}
