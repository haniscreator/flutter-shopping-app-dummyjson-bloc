import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'cart_state.dart';
import 'cart_event.dart';
import '../../models/cart_item_model.dart';

class CartBloc extends HydratedBloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateCartItemQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final existingItemIndex =
        state.cartItems.indexWhere((item) => item.id == event.item.id);
    final updatedCartItems = List<CartItem>.from(state.cartItems);

    if (existingItemIndex != -1) {
      final existingItem = updatedCartItems[existingItemIndex];
      updatedCartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.item.quantity,
      );
    } else {
      updatedCartItems.add(event.item);
    }

    emit(state.copyWith(
      cartItems: updatedCartItems,
      totalPrice: _calculateTotalPrice(updatedCartItems),
      totalItems: _calculateTotalItems(updatedCartItems),
    ));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final updatedCartItems =
        state.cartItems.where((item) => item.id != event.productId).toList();

    emit(state.copyWith(
      cartItems: updatedCartItems,
      totalPrice: _calculateTotalPrice(updatedCartItems),
      totalItems: _calculateTotalItems(updatedCartItems),
    ));
  }

  void _onUpdateCartItemQuantity(UpdateCartItemQuantityEvent event, Emitter<CartState> emit) {
  
  final updatedCartItems = state.cartItems.map((item) {
    if (item.id == event.productId) {
      return item.copyWith(quantity: event.quantity);
    }
    return item;
  }).toList();

    emit(state.copyWith(
      cartItems: updatedCartItems,
      totalPrice: _calculateTotalPrice(updatedCartItems),
      totalItems: _calculateTotalItems(updatedCartItems),
    ));
  }


  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(CartState.initial());
  }

  double _calculateTotalPrice(List<CartItem> items) {
    return items.fold(0.0, (total, item) => total + item.totalPrice);
  }

  int _calculateTotalItems(List<CartItem> items) {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  // ✅ HydratedBloc overrides for caching
  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      return CartState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    return state.toJson();
  }
}

