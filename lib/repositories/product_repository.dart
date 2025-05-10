import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

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

}
