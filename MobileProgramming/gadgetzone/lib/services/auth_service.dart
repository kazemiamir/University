import 'dart:io' show SocketException;
import 'dart:async' show TimeoutException;
import 'sms_service.dart';
import 'user_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class AuthService {
  static DateTime? _lastAttempt;
  static const _cooldown = Duration(seconds: 60);
  static String? userPhone;
  static Map<String, Map<String, dynamic>> _pendingUsers = {};
  static final supabase = Supabase.instance.client;
  static const String smsApiUrl = 'YOUR_SMS_API_URL'; // آدرس API پیامک را اینجا قرار دهید

  String _getReadableError(dynamic error) {
    print('Error details: $error');
    
    if (error is TimeoutException) {
      return 'زمان پاسخگویی سرور به پایان رسید. لطفاً دوباره تلاش کنید';
    } else if (error is SocketException) {
      return 'خطا در اتصال به سرور. لطفاً اتصال اینترنت خود را بررسی کنید';
    }
    
    return 'خطایی رخ داد. لطفاً دوباره تلاش کنید. جزئیات: $error';
  }

  Future<bool> startSignUp({
    required String name,
    required String phone,
    required String password,
    required String username,
  }) async {
    try {
      if (_lastAttempt != null) {
        final timeSinceLastAttempt = DateTime.now().difference(_lastAttempt!);
        if (timeSinceLastAttempt < _cooldown) {
          final remainingSeconds = _cooldown.inSeconds - timeSinceLastAttempt.inSeconds;
          throw 'لطفاً $remainingSeconds ثانیه صبر کنید و دوباره تلاش کنید';
        }
      }

      String formattedPhone = phone.startsWith('0') ? phone : '0$phone';
      if (formattedPhone.length != 11) {
        throw 'شماره موبایل نامعتبر است';
      }

      final isRegistered = await UserManager.isPhoneNumberTaken(formattedPhone);
      if (isRegistered) {
        throw 'این شماره موبایل قبلاً ثبت شده است';
      }

      final otp = SMSService.generateOTP();
      final success = await SMSService.sendOTP(formattedPhone, otp);

      if (!success) {
        throw 'خطا در ارسال پیامک';
      }

      _pendingUsers[formattedPhone] = {
        'name': name,
        'phone': formattedPhone,
        'password': password,
        'username': username,
        'otp': otp,
      };

      userPhone = formattedPhone;
      _lastAttempt = DateTime.now();

      return true;
    } catch (e) {
      print('خطا در شروع ثبت‌نام: $e');
      throw _getReadableError(e);
    }
  }

  Future<Map<String, dynamic>> completeSignUp({
    required String phone,
    required String token,
  }) async {
    try {
      String formattedPhone = phone.startsWith('0') ? phone : '0$phone';
      
      final userData = _pendingUsers[formattedPhone];
      if (userData == null) {
        throw 'لطفاً دوباره تلاش کنید';
      }

      if (userData['otp'] != token) {
        throw 'کد تایید نامعتبر است';
      }

      await UserManager.saveUser(
        name: userData['name'],
        phone: formattedPhone,
        username: userData['username'],
        password: userData['password'],
      );

      _pendingUsers.remove(formattedPhone);
      
      return {
        'name': userData['name'],
        'phone': formattedPhone,
        'username': userData['username'],
      };
    } catch (e) {
      print('خطا در تکمیل ثبت‌نام: $e');
      throw _getReadableError(e);
    }
  }

  Future<bool> signIn({
    required String phone,
    required String password,
  }) async {
    try {
      String formattedPhone = phone.startsWith('0') ? phone : '0$phone';
      
      final success = await UserManager.loginUser(
        phone: formattedPhone,
        password: password,
      );

      return success;
    } catch (e) {
      print('خطا در ورود: $e');
      throw _getReadableError(e);
    }
  }

  Future<void> signOut() async {
    await UserManager.logout();
  }

  Future<bool> isPhoneNumberTaken(String phone) async {
    try {
      String formattedPhone = phone.startsWith('0') ? phone : '0$phone';
      final user = await UserManager.getUser();
      return user != null && user['phone'] == formattedPhone;
    } catch (e) {
      print('Error in isPhoneNumberTaken: $e');
      throw _getReadableError(e);
    }
  }

  // تابع ارسال کد تایید
  static Future<bool> sendVerificationCode(String phoneNumber) async {
    try {
      final code = _generateVerificationCode();
      // اینجا کد ارسال پیامک از طریق API پیامک شما قرار می‌گیرد
      // await _sendSMS(phoneNumber, code);
      return true;
    } catch (e) {
      print('Error sending verification code: $e');
      return false;
    }
  }

  // تابع ثبت‌نام کاربر جدید
  static Future<bool> registerUser({
    required String name,
    required String phone,
    required String username,
    required String password,
  }) async {
    try {
      // بررسی تکراری نبودن شماره تلفن و نام کاربری
      final existingUsers = await supabase
          .from('users')
          .select()
          .or('phone.eq.$phone,username.eq.$username');

      if (existingUsers.length > 0) {
        throw 'شماره تلفن یا نام کاربری قبلاً ثبت شده است';
      }

      // هش کردن رمز عبور
      final hashedPassword = _hashPassword(password);

      // ذخیره اطلاعات کاربر در دیتابیس
      await supabase.from('users').insert({
        'name': name,
        'phone': phone,
        'username': username,
        'password': hashedPassword,
      });

      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // تابع ورود کاربر
  static Future<Map<String, dynamic>?> loginUser({
    required String phone,
    required String password,
  }) async {
    try {
      final hashedPassword = _hashPassword(password);
      
      final response = await supabase
          .from('users')
          .select()
          .eq('phone', phone)
          .eq('password', hashedPassword)
          .single();

      if (response != null) {
        return response;
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // تولید کد تایید تصادفی
  static String _generateVerificationCode() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString(); // کد 6 رقمی
  }

  // هش کردن رمز عبور
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
} 