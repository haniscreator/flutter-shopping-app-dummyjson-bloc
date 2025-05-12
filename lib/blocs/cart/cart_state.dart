import 'dart:convert';
import '../../models/cart_item_model.dart';

class CartState {
  final List<CartItem> cartItems;
  final double totalPrice;
  final int totalItems;

  CartState({
    required this.cartItems,
    required this.totalPrice,
    required this.totalItems,
  });

  // Initial empty state
  factory CartState.initial() {
    return CartState(
      cartItems: [],
      totalPrice: 0.0,
      totalItems: 0,
    );
  }

  // Clone with updates
  CartState copyWith({
    List<CartItem>? cartItems,
    double? totalPrice,
    int? totalItems,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  // Factory constructor to create CartState from JSON (for HydratedBloc)
  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      cartItems: (json['cartItems'] as List)
          .map((itemJson) => CartItem.fromJson(itemJson))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      totalItems: json['totalItems'],
    );
  }

  // Method to convert CartState to JSON (for HydratedBloc)
  Map<String, dynamic> toJson() {
    return {
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'totalItems': totalItems,
    };
  }
}
