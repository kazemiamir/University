import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final supabase = Supabase.instance.client;
  
  static Future<void> initializeDatabase() async {
    try {
      // Create users table if not exists with password column
      await supabase.from('users').select().limit(1);
    } catch (e) {
      print('Creating users table...');
      await supabase.rpc('create_users_table_with_password', params: {
        'query': '''
          CREATE TABLE IF NOT EXISTS public.users (
            id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
            name TEXT NOT NULL,
            phone TEXT UNIQUE NOT NULL,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          );
        '''
      });
    }

    try {
      // Check if password column exists
      await supabase.from('users').select('password').limit(1);
    } catch (e) {
      if (e.toString().contains("Could not find the 'password' column")) {
        print('Adding password column...');
        // Add password column if it doesn't exist
        await supabase.rpc('add_password_column', params: {
          'query': '''
            ALTER TABLE public.users 
            ADD COLUMN IF NOT EXISTS password TEXT;
          '''
        });
      } else {
        rethrow;
      }
    }
  }
} 