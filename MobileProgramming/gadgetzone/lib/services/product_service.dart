import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import '../services/supabase_config.dart';
import '../data/dummy_categories.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _table = 'products';

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .order('created_at', ascending: false);
      
      if (response == null || (response as List).isEmpty) {
        return [];
      }

      return (response as List)
          .map((product) => Product.fromJson(product))
          .toList();
          
    } catch (e) {
      throw Exception('خطا در دریافت محصولات: $e');
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
      print('🔍 دسته‌بندی درخواستی: $category');
      
      // اول همه محصولات را دریافت کنیم تا ببینیم چه دسته‌بندی‌هایی داریم
      final allProducts = await _supabase
          .from(_table)
          .select();
      
      print('📊 تعداد کل محصولات: ${allProducts.length}');
      print('📑 دسته‌بندی‌های موجود در دیتابیس:');
      final categories = (allProducts as List).map((p) => p['category']).toSet();
      categories.forEach((cat) => print('   - "$cat"'));

      print('\n🔎 جستجوی محصولات با دسته‌بندی: "$category"');
      // حالا محصولات دسته‌بندی مورد نظر را دریافت کنیم
      final response = await _supabase
          .from(_table)
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);
      
      print('📦 تعداد محصولات پیدا شده: ${response.length}');
      
      if (response.isEmpty) {
        print('⚠️ هیچ محصولی در این دسته‌بندی یافت نشد!');
        print('💡 پیشنهاد: بررسی کنید که نام دسته‌بندی دقیقاً مطابق با مقادیر موجود در دیتابیس باشد');
        return [];
      }
      
      final products = (response as List)
          .map((product) {
            try {
              return Product.fromJson(product);
            } catch (e) {
              print('❌ خطا در تبدیل داده محصول:');
              print('   داده خام: $product');
              print('   پیام خطا: $e');
              rethrow;
            }
          })
          .toList();
      
      print('✅ محصولات این دسته‌بندی:');
      products.forEach((p) => print('   - ${p.name}'));
      print('=================================\n');
      
      return products;
    } catch (e) {
      print('❌ خطا در دریافت محصولات دسته‌بندی:');
      print('   نوع خطا: ${e.runtimeType}');
      print('   پیام خطا: $e');
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

  Future<void> checkCategoryMappings() async {
    try {
      final allProducts = await _supabase
          .from(_table)
          .select('category');
      
      final dbCategories = (allProducts as List)
          .map((p) => p['category'] as String)
          .toSet();
      
      final appCategories = dummyCategories
          .map((c) => c.name)
          .toSet();
      
      final missingInDb = appCategories.difference(dbCategories);
      final missingInApp = dbCategories.difference(appCategories);
      
      if (missingInDb.isNotEmpty || missingInApp.isNotEmpty) {
        throw Exception('عدم تطابق در دسته‌بندی‌ها');
      }
    } catch (e) {
      throw Exception('خطا در بررسی دسته‌بندی‌ها: $e');
    }
  }
} 