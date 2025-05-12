import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(
              child: Text('Your cart is empty.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return ListTile(
                      leading: Image.network(
                        item.thumbnail,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.title),
                      subtitle: Text(
                        'Quantity: ${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (item.quantity > 1) {
                                context.read<CartBloc>().add(
                                  UpdateCartItemQuantityEvent(
                                    productId: item.id,
                                    quantity: item.quantity - 1,
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                UpdateCartItemQuantityEvent(
                                  productId: item.id,
                                  quantity: item.quantity + 1,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                RemoveFromCartEvent(productId: item.id),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${state.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
