import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
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
    context.read<ProductBloc>().add(LoadCategories()); // 👈 Add this line
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
    final bloc = context.read<ProductBloc>();
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
        builder: (context, state) {

          print("🔥 Categories from state: ${state.categories}");

          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // 🔍 Search Bar
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
                              
                              // 👇 Scroll to top
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

              // 🧭 Category Dropdown with Logging
              // Inside the ProductListScreen widget
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: state.categories.isEmpty
                    ? const Center(child: Text("No categories loaded"))
                    : DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Filter by category',
                          border: OutlineInputBorder(),
                        ),
                        // Use slug (or other property) for value, e.g., category.slug
                        value: state.selectedCategory,
                        items: state.categories.map((category) {
                          // Assuming category is of type Category and has a 'slug' and 'name'
                          return DropdownMenuItem<String>(
                            value: category.slug, // Use the slug here
                            child: Text(category.name), // Use the name here
                          );
                        }).toList(),
                        onChanged: (value) {
                          debugPrint("✅ Category selected: $value");
                          if (value != null) {
                            if (value == 'All') {
                              context.read<ProductBloc>().add(LoadInitialProducts());
                            } else {
                              context.read<ProductBloc>().add(
                                LoadProductsByCategory(category: value),
                              );
                            }

                            _scrollController.animateTo(
                              0.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        },


                      ),
              ),


              // 🧱 Product Grid
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: state.hasReachedEnd
                      ? state.products.length
                      : state.products.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= state.products.length) {
                      if (state.isLoadingMore) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const SizedBox.shrink();
                      }
                    }

                    final product = state.products[index];

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
      ),
    );
  }
}
