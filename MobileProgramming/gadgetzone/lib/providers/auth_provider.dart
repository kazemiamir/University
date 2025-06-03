import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _user;
  bool _isLoading = false;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(Map<String, dynamic>? userData) {
    _user = userData;
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
    required String username,
  }) async {
    try {
      setLoading(true);
      
      final success = await _authService.startSignUp(
        name: name,
        phone: phone,
        password: password,
        username: username,
      );

      if (success) {
        // Don't set user here, wait for OTP verification
        notifyListeners();
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> verifyOTP({
    required String phone,
    required String token,
  }) async {
    try {
      setLoading(true);
      final userData = await _authService.completeSignUp(
        phone: phone,
        token: token,
      );
      setUser(userData);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signIn({
    required String phone,
    required String password,
  }) async {
    try {
      setLoading(true);
      final success = await _authService.signIn(
        phone: phone,
        password: password,
      );
      if (success) {
        final userData = await _authService.isPhoneNumberTaken(phone);
        if (userData) {
          // Get user data from UserManager
          // This is just a placeholder, you might want to add more user data
          setUser({'phone': phone});
        }
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      setLoading(true);
      await _authService.signOut();
      setUser(null);
    } finally {
      setLoading(false);
    }
  }

  // چک کردن وضعیت لاگین و نمایش دیالوگ در صورت نیاز
  Future<bool> checkAuthAndShowDialog(BuildContext context) async {
    if (!isLoggedIn) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('نیاز به ورود'),
          content: const Text('برای افزودن به سبد خرید باید وارد حساب کاربری خود شوید.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('ورود'),
            ),
          ],
        ),
      );

      if (result == true) {
        if (context.mounted) {
          Navigator.pushNamed(context, '/login');
        }
        return false;
      }
      return false;
    }
    return true;
  }
} 