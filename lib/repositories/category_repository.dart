import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryRepository {
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
