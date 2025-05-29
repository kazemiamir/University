import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../data/dummy_products.dart';
import 'product_details_page.dart';
import 'cart_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CategoryProductsPage extends StatelessWidget {
  final Category category;

  const CategoryProductsPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProducts = dummyProducts
        .where((product) => product.category == category.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color?.withOpacity(0.2),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (ctx, cart, child) {
                    return cart.itemCount > 0
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: categoryProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category.icon,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'محصولی در این دسته‌بندی وجود ندارد',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categoryProducts.length,
              itemBuilder: (ctx, i) {
                final product = categoryProducts[i];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            product: product,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'product_${product.id}',
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (product.originalPrice != null)
                                        Text(
                                          '\$${product.originalPrice?.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    onPressed: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .addItem(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content:
                                              const Text('محصول به سبد خرید اضافه شد'),
                                          duration: const Duration(seconds: 2),
                                          action: SnackBarAction(
                                            label: 'مشاهده سبد خرید',
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CartPage(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
} 