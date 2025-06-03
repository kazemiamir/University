import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import '../services/supabase_config.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _table = 'products';

  Future<List<Product>> getAllProducts() async {
    try {
      print('\n=== شروع دریافت محصولات ===');
      print('جدول: $_table');
      
      // تست دسترسی به جدول
      try {
        final testResponse = await _supabase
            .from(_table)
            .select('count')
            .single();
        print('✅ دسترسی به جدول برقرار است');
        print('تعداد رکوردها: ${testResponse['count']}');
      } catch (e) {
        print('❌ خطا در دسترسی به جدول:');
        print('نوع خطا: ${e.runtimeType}');
        print('پیام خطا: $e');
      }
      
      final response = await _supabase
          .from(_table)
          .select()
          .order('created_at', ascending: false);
      
      print('=== DEBUG: Raw Supabase Response ===');
      print('Response type: ${response.runtimeType}');
      print('Response data: $response');
      
      if (response == null || (response as List).isEmpty) {
        print('⚠️ هیچ محصولی یافت نشد');
        return [];
      }

      final products = (response as List)
          .map((product) {
            try {
              return Product.fromJson(product);
            } catch (e) {
              print('❌ خطا در تبدیل محصول: $e');
              print('داده خام: $product');
              rethrow;
            }
          })
          .toList();
      
      print('✅ ${products.length} محصول با موفقیت دریافت شد');
      print('=================================');
      
      return products;
    } catch (e) {
      print('❌ خطا در دریافت محصولات:');
      print('نوع خطا: ${e.runtimeType}');
      print('پیام خطا: $e');
      rethrow;
    }
  }

  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .eq('is_featured', true)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } catch (e) {
      print('خطا در دریافت محصولات ویژه: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      print('\n=== شروع دریافت محصولات دسته‌بندی ===');
      print('دسته‌بندی درخواستی: $category');
      
      // اول همه محصولات را دریافت کنیم تا ببینیم چه دسته‌بندی‌هایی داریم
      final allProducts = await _supabase
          .from(_table)
          .select();
      
      print('تعداد کل محصولات: ${allProducts.length}');
      print('دسته‌بندی‌های موجود:');
      final categories = (allProducts as List).map((p) => p['category']).toSet();
      categories.forEach((cat) => print('- $cat'));

      // حالا محصولات دسته‌بندی مورد نظر را دریافت کنیم
      final response = await _supabase
          .from(_table)
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);
      
      print('تعداد محصولات پیدا شده: ${response.length}');
      
      final products = (response as List)
          .map((product) => Product.fromJson(product))
          .toList();
      
      print('محصولات این دسته‌بندی:');
      products.forEach((p) => print('- ${p.name}'));
      print('=================================\n');
      
      return products;
    } catch (e) {
      print('❌ خطا در دریافت محصولات دسته‌بندی:');
      print('نوع خطا: ${e.runtimeType}');
      print('پیام خطا: $e');
      rethrow;
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .eq('id', id)
          .single();
      
      return Product.fromJson(response);
    } catch (e) {
      print('خطا در دریافت محصول: $e');
      return null;
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await _supabase
        .from(_table)
        .insert(product.toJson())
        .select()
        .single();
    
    return Product.fromJson(response);
  }

  Future<Product> updateProduct(Product product) async {
    final response = await _supabase
        .from(_table)
        .update(product.toJson())
        .eq('id', product.id)
        .select()
        .single();
    
    return Product.fromJson(response);
  }

  Future<void> deleteProduct(String id) async {
    await _supabase
        .from(_table)
        .delete()
        .eq('id', id);
  }

  Future<void> updateStock(String productId, int newQuantity) async {
    try {
      await _supabase
          .from(_table)
          .update({'stock_quantity': newQuantity})
          .eq('id', productId);
    } catch (e) {
      print('خطا در به‌روزرسانی موجودی: $e');
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await _supabase
        .from(_table)
        .select()
        .textSearch('name', query)
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }
} 