import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/category_model.dart'; // Add this import

class ProductRepository {
  
  Future<List<Product>> fetchProducts({int limit = 6, int skip = 0}) async {
    final url = Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip');
    final response = await http.get(url);

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['products'] as List;
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final url = Uri.parse('https://dummyjson.com/products/search?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['products'] as List;
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/categories'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }


  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/category/$category'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];
      return productsJson.map<Product>((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

}
