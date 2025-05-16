import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';

import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';

import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_state.dart';
import '../blocs/favorites/favorites_event.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';
import 'package:fakestoreapi_app/screens/favorites_screen.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<ProductBloc>().add(LoadInitialProducts());
    context.read<CategoryBloc>().add(LoadCategories()); // 👈 Add this line
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          context.read<ProductBloc>().add(LoadMoreProducts());
        }
      });

    _loadCategoriesIfNeeded();  
  }

  Future<void> _loadCategoriesIfNeeded() async {
    // Data ရှိရင် Caache ကပြမယ် မရှိရင်တော့ API ကနေဆွဲမယ်
    final bloc = context.read<CategoryBloc>();
    if (bloc.state.categories.isEmpty) {
      bloc.add(LoadCategories());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, productState) {
          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              print("🔥 Categories from CategoryBloc: ${categoryState.categories}");

              if (productState.isLoading && productState.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  // 🔍 Search Bar remains the same...
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<ProductBloc>().add(SearchQueryChanged(''));
                                _scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                                setState(() {});
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        context.read<ProductBloc>().add(SearchQueryChanged(query));
                        setState(() {});
                      },
                    ),
                  ),

                  // 🧭 Updated Category Dropdown
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: categoryState.categories.isEmpty
                        ? const Center(child: Text("No categories loaded"))
                        : DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Filter by category',
                              border: OutlineInputBorder(),
                            ),
                            value: categoryState.selectedCategory,
                            items: categoryState.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.slug,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                if (value == 'All') {
                                  context.read<ProductBloc>().add(LoadInitialProducts());
                                } else {
                                  context.read<ProductBloc>().add(
                                    LoadProductsByCategory(category: value),
                                  );
                                }

                                context.read<CategoryBloc>().add(SelectCategoryEvent(value));

                                _scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                          ),
                  ),

                  // 🧱 Product Grid remains the same...
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: productState.hasReachedEnd
                          ? productState.products.length
                          : productState.products.length + 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //column (item) ၂
                        childAspectRatio: 2 / 3, //For Card Design
                        mainAxisSpacing: 8, //vertical (အပေါ်အောက်) spacing 
                        crossAxisSpacing: 8, //Column item တွေကြားမှာ 8 pixels ( horizontal )
                      ),
                      itemBuilder: (context, index) {
                        if (index >= productState.products.length) {
                          if (productState.isLoadingMore) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return const SizedBox.shrink();
                          }
                        }

                        final product = productState.products[index];

                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailsScreen(product: product),
                                  ),
                                );
                              },
                              child: ProductCard(product: product),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                                builder: (context, favState) {
                                  final isFavorite = favState.favorites
                                      .any((p) => p.id == product.id);
                                  return IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      context.read<FavoritesBloc>().add(
                                        ToggleFavoriteEvent(product: product),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
