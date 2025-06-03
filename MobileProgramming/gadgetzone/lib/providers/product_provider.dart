import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllProducts() async {
    _setLoading(true);
    try {
      _products = await _productService.getAllProducts();
      _error = null;
    } catch (e) {
      _error = 'خطا در بارگذاری محصولات: $e';
      print(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadFeaturedProducts() async {
    _setLoading(true);
    try {
      _featuredProducts = await _productService.getFeaturedProducts();
      _error = null;
    } catch (e) {
      _error = 'خطا در بارگذاری محصولات ویژه: $e';
      print(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await _productService.getProductsByCategory(category);
    } catch (e) {
      _error = 'خطا در دریافت محصولات دسته‌بندی: $e';
      print(_error);
      return [];
    }
  }

  Future<void> updateStock(String productId, int newQuantity) async {
    try {
      await _productService.updateStock(productId, newQuantity);
      // به‌روزرسانی محصول در لیست محلی
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = _products[index].copyWith(stockQuantity: newQuantity);
        notifyListeners();
      }
    } catch (e) {
      _error = 'خطا در به‌روزرسانی موجودی: $e';
      print(_error);
      rethrow;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
} 