import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service class to handle all Supabase related operations
class SupabaseService {
  static SupabaseClient? _client;

  /// Initialize Supabase client with credentials from .env file
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['https://djsjjgkwffqhlrtrdwda.supabase.co']!,
      anonKey: dotenv.env['eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqc2pqZ2t3ZmZxaGxydHJkd2RhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NTQ4OTgsImV4cCI6MjA2MzMzMDg5OH0.uIJ-T8gd5Rs4v-2O2MD5AmIcsmGCQvIFoZPStyevAC8']!,
    );
    _client = Supabase.instance.client;
  }

  /// Get the Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase client not initialized');
    }
    return _client!;
  }

  /// Get the current user if logged in
  static User? get currentUser => _client?.auth.currentUser;

  /// Check if a user is logged in
  static bool get isAuthenticated => currentUser != null;
} 