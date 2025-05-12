import 'package:equatable/equatable.dart';
import '../../models/cart_item_model.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final CartItem item;

  AddToCartEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;

  RemoveFromCartEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class UpdateCartItemQuantityEvent extends CartEvent {
  final int productId;
  final int quantity;

  UpdateCartItemQuantityEvent({
    required this.productId,
    required this.quantity,
  });
}

class ClearCartEvent extends CartEvent {}
