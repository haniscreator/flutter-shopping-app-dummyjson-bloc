import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart'; // Make sure to import CartItem model
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.thumbnail, height: 200),
            const SizedBox(height: 16),
            Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('\$${product.price}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text(product.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Add to Cart"),
                onPressed: () {
                  // Create a CartItem using the product details
                  final cartItem = CartItem(
                    id: product.id, // Use the product's id
                    title: product.title, // Use the product's title
                    price: product.price, // Use the product's price
                    thumbnail: product.thumbnail, // Use the product's thumbnail
                    quantity: 1, // Default quantity is 1 when added to the cart
                  );

                  // Add the cart item to the CartBloc
                  context.read<CartBloc>().add(AddToCartEvent(item: cartItem));

                  // Show confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
