import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl = 'https://api.gadgetzone.ir/api';

  // ثبت‌نام کاربر جدید
  static Future<Map<String, dynamic>?> signUp({
    required String name,
    required String phone,
    required String password,
    required String username,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'phone': phone,
          'password': password,
          'username': username,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error in signUp: $e');
      return null;
    }
  }

  // ورود با شماره موبایل و رمز عبور
  static Future<Map<String, dynamic>?> login(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error in login: $e');
      return null;
    }
  }

  // بررسی وجود شماره موبایل
  static Future<bool> isPhoneExists(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/phone/$phone'),
        headers: {'Content-Type': 'application/json'},
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // دریافت اطلاعات کاربر با شماره موبایل
  static Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/phone/$phone'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error in getUserByPhone: $e');
      return null;
    }
  }

  // به‌روزرسانی اطلاعات کاربر
  static Future<Map<String, dynamic>?> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error in updateUser: $e');
      return null;
    }
  }
} 