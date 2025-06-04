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
      _currentUser = await getCurrentUser();
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
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;

    final savedPhone = _prefs?.getString(_phoneKey);
    if (savedPhone == null) return null;

    try {
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
      throw Exception('خطا در دریافت اطلاعات کاربر: $e');
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
      throw Exception('خطا در تایید رمز عبور: $e');
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
      throw Exception('خطا در بررسی شماره موبایل: $e');
    }
  }

  // Login user
  static Future<bool> loginUser({
    required String phone,
    required String password,
  }) async {
    try {
      final user = await _supabase
          .from('users')
          .select()
          .eq('phone', phone)
          .maybeSingle();
      
      if (user == null) {
        throw 'کاربری با این شماره موبایل یافت نشد';
      }

      if (user['password'] != password) {
        throw 'رمز عبور اشتباه است';
      }

      _currentUser = user;
      await _prefs?.setString(_phoneKey, phone);
      return true;

    } catch (e) {
      if (e is String) {
        throw e;
      }
      throw 'خطا در ورود به سیستم';
    }
  }
} 