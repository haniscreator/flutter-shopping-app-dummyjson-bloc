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

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadInitialProducts());
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          context.read<ProductBloc>().add(LoadMoreProducts());
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Products')),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
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
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
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
                return const Center(child: CircularProgressIndicator());
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
                                ToggleFavoriteEvent(product: product));
                          },
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
