import 'package:flutter/services.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String description;
  final String brand;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
    required this.brand,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      description: json['description'] ?? '',
      brand: json['brand'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'thumbnail': thumbnail,
    'description' : description,
    'brand' : brand,
    'rating' : rating,
  };
}

