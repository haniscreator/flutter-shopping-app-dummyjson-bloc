// lib/models/cart_item_model.dart

class CartItem {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final int quantity;

  // Constructor for CartItem with required parameters: id, title, price, thumbnail, and quantity
  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
  });

  // Method to get the total price for this CartItem (price * quantity)
  double get totalPrice => price * quantity;

  // Method to copy the CartItem with the ability to modify the quantity (useful for updating items in the cart)
  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      title: title,
      price: price,
      thumbnail: thumbnail,
      quantity: quantity ?? this.quantity,
    );
  }

  // Factory constructor to create a CartItem from a JSON map
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      quantity: json['quantity'],
    );
  }

  // Method to convert CartItem to a JSON map (useful for saving or sending the data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'quantity': quantity,
    };
  }
}
