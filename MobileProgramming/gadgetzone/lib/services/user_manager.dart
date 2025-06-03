import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

class UserManager {
  static final _supabase = Supabase.instance.client;
  static const String _phoneKey = 'user_phone';
  static SharedPreferences? _prefs;
  static Map<String, dynamic>? _currentUser;

  // Initialize SharedPreferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    // Try to load user data if phone exists
    final savedPhone = _prefs?.getString(_phoneKey);
    if (savedPhone != null) {
      _currentUser = await getUser();
    }
  }

  // Get current user data
  static Map<String, dynamic>? get currentUser => _currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _currentUser != null;

  // ذخیره اطلاعات کاربر
  static Future<void> saveUser({
    required String name,
    required String phone,
    required String username,
    required String password,
  }) async {
    try {
      await _supabase.from('users').insert({
        'name': name,
        'phone': phone,
        'username': username,
        'password': password,
      });
      
      _currentUser = {
        'name': name,
        'phone': phone,
        'username': username,
      };
      
      await _prefs?.setString(_phoneKey, phone);
    } catch (e) {
      print('Error saving user: $e');
      throw 'خطا در ذخیره اطلاعات کاربر';
    }
  }

  // دریافت اطلاعات کاربر
  static Future<Map<String, dynamic>?> getUser() async {
    if (_currentUser != null) return _currentUser;
    
    try {
      final savedPhone = _prefs?.getString(_phoneKey);
      if (savedPhone == null) return null;

      final response = await _supabase
          .from('users')
          .select()
          .eq('phone', savedPhone)
          .single();
      
      if (response != null) {
        _currentUser = response;
        return _currentUser;
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // حذف اطلاعات کاربر
  static Future<void> logout() async {
    _currentUser = null;
    await _prefs?.remove(_phoneKey);
  }

  // بررسی اعتبار رمز عبور
  static Future<bool> validatePassword(String phone, String password) async {
    try {
      final user = await _supabase
          .from('users')
          .select()
          .eq('phone', phone)
          .maybeSingle();
      
      if (user == null) return false;
      return user['password'] == password;
    } catch (e) {
      print('Error validating password: $e');
      return false;
    }
  }

  // بررسی تکراری بودن شماره موبایل
  static Future<bool> isPhoneNumberTaken(String phone) async {
    try {
      final response = await _supabase
          .from('users')
          .select('phone')
          .eq('phone', phone)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      print('Error checking phone number: $e');
      return false;
    }
  }

  // Login user
  static Future<bool> loginUser({
    required String phone,
    required String password,
  }) async {
    try {
      print('Attempting login for phone: $phone');
      
      // اول چک می‌کنیم کاربر با این شماره وجود داره یا نه
      final user = await _supabase
          .from('users')
          .select()
          .eq('phone', phone)
          .maybeSingle();
      
      if (user == null) {
        print('No user found with phone: $phone');
        throw 'کاربری با این شماره موبایل یافت نشد';
      }

      // حالا رمز عبور رو چک می‌کنیم
      if (user['password'] != password) {
        print('Invalid password for phone: $phone');
        throw 'رمز عبور اشتباه است';
      }

      // اگر همه چیز درست بود، اطلاعات کاربر رو ذخیره می‌کنیم
      _currentUser = user;
      await _prefs?.setString(_phoneKey, phone);
      print('Login successful for phone: $phone');
      return true;

    } catch (e) {
      print('Error in login: $e');
      if (e is String) {
        throw e;
      }
      throw 'خطا در ورود به سیستم';
    }
  }
} 