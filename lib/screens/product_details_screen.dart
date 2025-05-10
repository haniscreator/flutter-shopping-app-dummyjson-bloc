import 'package:flutter/material.dart';
import '../models/product_model.dart';


class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.thumbnail, height: 250, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Brand: ${product.brand}"),
            Text("Price: \$${product.price.toStringAsFixed(2)}"),
            Text("Rating: ${product.rating}/5 ⭐️"),
            const SizedBox(height: 16),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
