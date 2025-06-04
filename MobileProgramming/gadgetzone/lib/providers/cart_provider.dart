import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get totalSaved {
    return _items.values.fold(0.0, (sum, item) => sum + (item.savedAmount ?? 0));
  }

  Future<bool> addItem(Product product, BuildContext context) async {
    // چک کردن وضعیت لاگین
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAuthenticated = await authProvider.checkAuthAndShowDialog(context);
    
    if (!isAuthenticated) {
      return false;
    }

    // بررسی موجودی محصول
    if (product.stockQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('این محصول در حال حاضر ناموجود است'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    // بررسی موجودی برای افزایش تعداد
    if (_items.containsKey(product.id)) {
      final currentQuantity = _items[product.id]!.quantity;
      if (currentQuantity >= product.stockQuantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('موجودی محصول کافی نیست'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    }

    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product),
      );
    }
    notifyListeners();
    return true;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
} 