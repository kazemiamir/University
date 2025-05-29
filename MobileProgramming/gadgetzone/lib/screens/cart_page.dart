library cart_page;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سبد خرید'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('حذف همه'),
                  content: const Text('آیا می‌خواهید همه محصولات را از سبد خرید حذف کنید؟'),
                  actions: [
                    TextButton(
                      child: const Text('خیر'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    TextButton(
                      child: const Text('بله'),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).clear();
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'سبد خرید شما خالی است',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) {
                    final cartItem = cart.items.values.toList()[i];
                    return Dismissible(
                      key: ValueKey(cartItem.product.id),
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('حذف محصول'),
                            content: const Text(
                              'آیا می‌خواهید این محصول را از سبد خرید حذف کنید؟',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('خیر'),
                                onPressed: () => Navigator.of(ctx).pop(false),
                              ),
                              TextButton(
                                child: const Text('بله'),
                                onPressed: () => Navigator.of(ctx).pop(true),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        Provider.of<CartProvider>(context, listen: false)
                            .removeItem(cartItem.product.id);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.network(
                                cartItem.product.imageUrl,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  );
                                },
                              ),
                            ),
                            title: Text(cartItem.product.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${cartItem.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                if (cartItem.savedAmount != null)
                                  Text(
                                    'صرفه‌جویی: \$${cartItem.savedAmount!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .removeSingleItem(cartItem.product.id);
                                  },
                                ),
                                Text('${cartItem.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .addItem(cartItem.product);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cart.totalSaved > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'مجموع صرفه‌جویی:',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '\$${cart.totalSaved.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'مجموع:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement checkout
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'ادامه فرآیند خرید',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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