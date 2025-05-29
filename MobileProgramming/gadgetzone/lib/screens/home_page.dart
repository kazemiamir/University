import 'package:flutter/material.dart';
import '../data/dummy_products.dart';
import '../models/product_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/special_offer_model.dart';
import 'product_details_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart_page.dart';
import '../data/dummy_categories.dart';
import 'category_products_page.dart';
import 'products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 0.9);
  String _searchQuery = '';
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _autoScrollBanners();
    });
  }

  void _autoScrollBanners() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final nextPage = (_currentBannerIndex + 1) % dummyBanners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _autoScrollBanners();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = dummyProducts
        .where((product) =>
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final featuredProducts = dummyProducts.where((p) => p.isFeatured).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('گجت زون'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // دسته‌بندی‌ها
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'دسته‌بندی‌ها',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductsPage(),
                        ),
                      );
                    },
                    child: const Text('مشاهده همه محصولات'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: dummyCategories.length,
                itemBuilder: (ctx, i) {
                  final category = dummyCategories[i];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsPage(
                              category: category,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: category.color?.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              category.icon,
                              size: 40,
                              color: category.color,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (category.description != null)
                            Text(
                              category.description!,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // محصولات ویژه
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'پیشنهادهای ویژه',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: featuredProducts.length,
                itemBuilder: (ctx, i) {
                  final product = featuredProducts[i];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.all(8),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/product-details',
                            arguments: product,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'محصول به سبد خرید اضافه شد'),
                                              duration:
                                                  const Duration(seconds: 2),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(product: product),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 