import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../data/dummy_products.dart';
import 'product_details_page.dart';
import 'cart_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _searchQuery = '';
  String _selectedCategory = '';
  String _sortBy = 'name'; // name, price, newest
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(dummyProducts);
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = dummyProducts.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (product.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
        final matchesCategory = _selectedCategory.isEmpty || product.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();

      switch (_sortBy) {
        case 'name':
          _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'price':
          _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'newest':
          // در حالت واقعی، باید بر اساس تاریخ اضافه شدن مرتب شود
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محصولات'),
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'جستجو در محصولات...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          _filterProducts();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _filterProducts();
              },
            ),
          ),

          // Filter and Sort Options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Category Filter
                DropdownButton<String>(
                  hint: const Text('دسته‌بندی'),
                  value: _selectedCategory.isEmpty ? null : _selectedCategory,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('همه'),
                    ),
                    ...dummyProducts
                        .map((p) => p.category)
                        .toSet()
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? '';
                    });
                    _filterProducts();
                  },
                ),
                const SizedBox(width: 16),

                // Sort Options
                DropdownButton<String>(
                  hint: const Text('مرتب‌سازی'),
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(
                      value: 'name',
                      child: Text('نام'),
                    ),
                    DropdownMenuItem(
                      value: 'price',
                      child: Text('قیمت'),
                    ),
                    DropdownMenuItem(
                      value: 'newest',
                      child: Text('جدیدترین'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value ?? 'name';
                    });
                    _filterProducts();
                  },
                ),
              ],
            ),
          ),

          // Products Grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'محصولی یافت نشد',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (ctx, i) {
                      final product = _filteredProducts[i];
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
                                                color:
                                                    Theme.of(context).primaryColor,
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 