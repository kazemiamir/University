import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io' show SocketException;
import 'dart:async' show TimeoutException;
import 'supabase_config.dart';

class AuthService {
  SupabaseClient get _supabase => SupabaseConfig.client;
  static DateTime? _lastEmailAttempt;
  static const _emailCooldown = Duration(seconds: 60);
  static String? userEmail; // Public static variable for email

  String _getReadableError(dynamic error) {
    print('Error details: $error'); // For debugging
    
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'نام کاربری یا رمز عبور اشتباه است';
        case 'Email already registered':
          return 'این ایمیل قبلاً ثبت شده است';
        case 'User already registered':
          return 'این کاربر قبلاً ثبت شده است';
        case 'Invalid email':
          return 'ایمیل نامعتبر است';
        default:
          if (error.message.contains('rate limit')) {
            return 'لطفاً ۶۰ ثانیه صبر کنید و دوباره تلاش کنید';
          }
          return 'خطا در احراز هویت: ${error.message}';
      }
    } else if (error is TimeoutException) {
      return 'زمان پاسخگویی سرور به پایان رسید. لطفاً دوباره تلاش کنید';
    } else if (error is SocketException || error.toString().contains('SocketException')) {
      return 'خطا در اتصال به سرور. لطفاً اتصال اینترنت خود را بررسی کنید';
    } else if (error.toString().contains('ClientException')) {
      return 'خطا در ارتباط با سرور. لطفاً دوباره تلاش کنید';
    } else if (error.toString().contains('TimeoutException')) {
      return 'زمان پاسخگویی سرور به پایان رسید. لطفاً دوباره تلاش کنید';
    } else if (error.toString().contains('Failed host lookup')) {
      return 'خطا در پیدا کردن سرور. لطفاً از VPN استفاده کنید';
    }
    
    return 'خطایی رخ داد. لطفاً دوباره تلاش کنید. جزئیات: $error';
  }

  Future<AuthResponse?> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Check email cooldown
      if (_lastEmailAttempt != null) {
        final timeSinceLastAttempt = DateTime.now().difference(_lastEmailAttempt!);
        if (timeSinceLastAttempt < _emailCooldown) {
          final remainingSeconds = _emailCooldown.inSeconds - timeSinceLastAttempt.inSeconds;
          throw 'لطفاً $remainingSeconds ثانیه صبر کنید و دوباره تلاش کنید';
        }
      }

      // Create auth user with additional data
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null,
        data: {
          'name': name,
          'phone': phone,
          'username': username,
        },
      );

      if (res.user != null) {
        // Update last email attempt time
        _lastEmailAttempt = DateTime.now();

        try {
          // Insert user data directly into the users table
          await _supabase.from('users').insert({
            'id': res.user!.id,
            'name': name,
            'phone': phone,
            'email': email,
            'username': username,
            'created_at': DateTime.now().toIso8601String(),
          }).select();

          // Try to sign in immediately after signup
          await _supabase.auth.signInWithPassword(
            email: email,
            password: password,
          );

          return res;
        } catch (dbError) {
          print('Error inserting user data: $dbError');
          // Sign out the user if we couldn't save their profile data
          await _supabase.auth.signOut();
          throw 'خطا در ذخیره اطلاعات کاربر';
        }
      }

      return res;
    } catch (e) {
      throw _getReadableError(e);
    }
  }

  Future<void> signIn({
    required String phone,
  }) async {
    try {
      // First, find the user's email using their phone number
      final response = await _supabase
          .from('users')
          .select('email')
          .eq('phone', phone)
          .single();

      if (response == null || response['email'] == null) {
        throw 'کاربری با این شماره موبایل یافت نشد';
      }

      final email = response['email'] as String;

      // Send OTP to user's email
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: null,
        data: {'phone': phone},
      );

      // Store email for verification
      userEmail = email;

      return;
    } catch (e) {
      if (e is String) {
        throw e;
      }
      throw _getReadableError(e);
    }
  }

  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
      return response;
    } catch (e) {
      throw _getReadableError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw _getReadableError(e);
    }
  }

  Future<bool> isPhoneNumberTaken(String phone) async {
    try {
      final data = await _supabase
          .from('users')
          .select('phone')
          .eq('phone', phone)
          .maybeSingle();
      return data != null;
    } catch (e) {
      throw _getReadableError(e);
    }
  }

  Future<bool> isEmailTaken(String email) async {
    try {
      final data = await _supabase
          .from('users')
          .select('email')
          .eq('email', email)
          .maybeSingle();
      return data != null;
    } catch (e) {
      throw _getReadableError(e);
    }
  }
} 