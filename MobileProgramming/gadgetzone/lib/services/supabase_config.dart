import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

class SupabaseConfig {
  // Project URL and anon key from Project Settings > API
  static const String url = 'https://djsjjgkwffqhlrtrdwda.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqc2pqZ2t3ZmZxaGxydHJkd2RhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NTQ4OTgsImV4cCI6MjA2MzMzMDg5OH0.uIJ-T8gd5Rs4v-2O2MD5AmIcsmGCQvIFoZPStyevAC8';
  
  // اضافه کردن تنظیمات شبکه
  static const Duration _dnsTimeout = Duration(seconds: 10);
  static const Duration _connectTimeout = Duration(seconds: 15);
  static const Duration _sendTimeout = Duration(seconds: 15);
  static const Duration _receiveTimeout = Duration(seconds: 15);

  static bool _isInitialized = false;
  static SupabaseClient? _client;
  static const int _timeoutSeconds = 60;

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase هنوز مقداردهی نشده است');
    }
    return _client!;
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('\n=== شروع عیب‌یابی اتصال ===');
      
      // تست اولیه اتصال به اینترنت
      final hasInternet = await _checkInternetConnection();
      if (!hasInternet) {
        throw Exception('اتصال به اینترنت برقرار نیست');
      }

      // تست دسترسی به سرور Supabase
      final canAccessSupabase = await _checkSupabaseAccess();
      if (!canAccessSupabase) {
        throw Exception('دسترسی به سرور Supabase امکان‌پذیر نیست');
      }

      print('شروع اتصال به Supabase...');
      final stopwatch = Stopwatch()..start();
      
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        debug: true,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.implicit,
          autoRefreshToken: true,
        ),
        storageOptions: const StorageClientOptions(
          retryAttempts: 3,
        ),
      ).timeout(
        Duration(seconds: _timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('زمان اتصال به پایان رسید (${stopwatch.elapsed.inSeconds} ثانیه)');
        },
      );

      _client = Supabase.instance.client;
      _isInitialized = true;
      
      print('اتصال با موفقیت برقرار شد (${stopwatch.elapsed.inMilliseconds}ms)');

    } catch (e) {
      print('\n!!! خطا در اتصال !!!');
      print('نوع خطا: ${e.runtimeType}');
      print('پیام خطا: $e');
      rethrow;
    }
  }

  static Future<bool> _checkInternetConnection() async {
    try {
      print('تست اتصال به اینترنت...');
      final result = await InternetAddress.lookup('google.com')
          .timeout(_dnsTimeout);
      final hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      print(hasConnection ? '✅ اتصال به اینترنت برقرار است' : '❌ اتصال به اینترنت برقرار نیست');
      return hasConnection;
    } catch (e) {
      print('❌ خطا در اتصال به اینترنت: $e');
      return false;
    }
  }

  static Future<bool> _checkSupabaseAccess() async {
    try {
      print('تست دسترسی به Supabase...');
      final response = await http.get(
        Uri.parse('$url/auth/v1/health'),
        headers: {'apikey': anonKey},
      ).timeout(_connectTimeout);
      
      final isAccessible = response.statusCode == 200;
      print(isAccessible ? '✅ دسترسی به Supabase برقرار است' : '❌ دسترسی به Supabase برقرار نیست');
      if (!isAccessible) {
        print('کد وضعیت: ${response.statusCode}');
        print('پاسخ: ${response.body}');
      }
      return isAccessible;
    } catch (e) {
      print('❌ خطا در دسترسی به Supabase: $e');
      return false;
    }
  }

  static void _printDiagnostics(Map<String, dynamic> diagnostics) {
    print('\nنتایج عیب‌یابی:');
    print('اتصال به اینترنت: ${diagnostics['internet_connection']}');
    if (diagnostics['internet_error'] != null) {
      print('خطای اینترنت: ${diagnostics['internet_error']}');
    }
    
    print('\nوضعیت DNS:');
    print('حل DNS: ${diagnostics['dns_resolution']}');
    if (diagnostics['resolved_ips'] != null) {
      print('آدرس‌های IP: ${diagnostics['resolved_ips']}');
    }
    if (diagnostics['dns_error'] != null) {
      print('خطای DNS: ${diagnostics['dns_error']}');
    }
    
    print('\nاتصال HTTPS:');
    print('وضعیت: ${diagnostics['https_connection']}');
    if (diagnostics['https_status'] != null) {
      print('کد وضعیت: ${diagnostics['https_status']}');
    }
    if (diagnostics['https_error'] != null) {
      print('خطای HTTPS: ${diagnostics['https_error']}');
    }
    
    print('\nبررسی API:');
    print('وضعیت: ${diagnostics['api_connection']}');
    if (diagnostics['api_status'] != null) {
      print('کد وضعیت: ${diagnostics['api_status']}');
    }
    if (diagnostics['api_error'] != null) {
      print('خطای API: ${diagnostics['api_error']}');
    }

    if (diagnostics['general_error'] != null) {
      print('\nخطای کلی: ${diagnostics['general_error']}');
    }
    print('\n=== پایان عیب‌یابی ===\n');
  }

  static bool _checkDiagnosticsResults(Map<String, dynamic> diagnostics) {
    final checks = <String, bool>{
      'internet_connection': diagnostics['internet_connection'] ?? false,
      'dns_resolution': diagnostics['dns_resolution'] ?? false,
      'https_connection': diagnostics['https_connection'] ?? false,
      'api_connection': diagnostics['api_connection'] ?? false,
    };

    final failedChecks = checks.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();

    if (failedChecks.isNotEmpty) {
      print('\nموارد خطا:');
      for (final check in failedChecks) {
        print('- $check');
      }
      return false;
    }

    return true;
  }

  static Future<Map<String, dynamic>> _runConnectionDiagnostics() async {
    final diagnostics = <String, dynamic>{};
    
    try {
      // Test 1: Basic Internet Connectivity with timeout
      try {
        print('\nتست DNS گوگل...');
        final result = await InternetAddress.lookup('google.com')
            .timeout(_dnsTimeout);
        diagnostics['internet_connection'] = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        print('DNS گوگل موفق: ${diagnostics['internet_connection']}');
      } catch (e) {
        diagnostics['internet_connection'] = false;
        diagnostics['internet_error'] = e.toString();
        print('خطا در DNS گوگل: $e');
      }

      // Test 2: DNS Resolution with multiple attempts
      try {
        print('\nتست DNS سوپابیس...');
        final uri = Uri.parse(url);
        print('تلاش برای حل DNS: ${uri.host}');
        
        final dnsResult = await InternetAddress.lookup(uri.host)
            .timeout(_dnsTimeout);
        diagnostics['dns_resolution'] = true;
        diagnostics['resolved_ips'] = dnsResult.map((e) => e.address).toList();
        print('آدرس‌های IP یافت شده: ${diagnostics['resolved_ips']}');
      } catch (e) {
        diagnostics['dns_resolution'] = false;
        diagnostics['dns_error'] = e.toString();
        print('خطا در DNS سوپابیس: $e');
      }

      // Test 3: HTTPS Connection with detailed error handling
      try {
        print('\nتست اتصال HTTPS...');
        final response = await http.get(
          Uri.parse(url),
          headers: {'apikey': anonKey},
        ).timeout(_connectTimeout);
        
        diagnostics['https_connection'] = response.statusCode < 500;
        diagnostics['https_status'] = response.statusCode;
        print('کد وضعیت HTTPS: ${response.statusCode}');
      } catch (e) {
        diagnostics['https_connection'] = false;
        diagnostics['https_error'] = e.toString();
        print('خطا در اتصال HTTPS: $e');
      }

      // Test 4: API Health Check
      try {
        print('\nتست سلامت API...');
        final response = await http.get(
          Uri.parse('$url/rest/v1/health'),
          headers: {'apikey': anonKey},
        ).timeout(_connectTimeout);
        
        diagnostics['api_connection'] = response.statusCode < 500;
        diagnostics['api_status'] = response.statusCode;
        print('کد وضعیت API: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          print('پاسخ API: ${response.body}');
        }
      } catch (e) {
        diagnostics['api_connection'] = false;
        diagnostics['api_error'] = e.toString();
        print('خطا در تست API: $e');
      }

    } catch (e) {
      diagnostics['general_error'] = e.toString();
      print('خطای کلی در تشخیص: $e');
    }

    return diagnostics;
  }

  static Future<bool> checkConnection() async {
    try {
      if (!_isInitialized || _client == null) {
        return false;
      }

      final response = await _client!.from('users')
          .select('id')
          .limit(1)
          .maybeSingle();
      
      return true;
    } catch (e) {
      print('خطا در تست اتصال: $e');
      return false;
    }
  }

  static Future<void> resetConnection() async {
    _isInitialized = false;
    _client = null;
    await initialize();
  }
} 