import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../view-model/cart_store.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartStore = Provider.of<CartStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Observer(builder: (_) {
        if (cartStore.cartItems.isEmpty) {
          return const Center(
            child: Text('Your cart is empty.'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartStore.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartStore.cartItems[index];
                  return ListTile(
                    leading: Image.network(item.imagem ?? ''), // Or use your CachedNetworkImageBuilder
                    title: Text(item.nome ?? ''),
                    subtitle: Text('R\$ ${item.preco?.toStringAsFixed(2) ?? ''}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        cartStore.removeFromCart(item);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Total: R\$ ${cartStore.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement checkout logic
                    },
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}