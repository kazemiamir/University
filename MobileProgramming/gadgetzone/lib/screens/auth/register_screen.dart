import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';
import 'dart:math';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  String _generatedUsername = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generatedUsername = _generateUsername();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _generateUsername() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final result = StringBuffer('user_');
    
    for (var i = 0; i < 8; i++) {
      result.write(chars[random.nextInt(chars.length)]);
    }
    
    return result.toString();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check if phone number is already taken
        final isPhoneTaken = await _authService.isPhoneNumberTaken(_phoneController.text);
        if (isPhoneTaken) {
          _showError('این شماره موبایل قبلاً ثبت شده است');
          return;
        }

        // Check if email is already taken
        final isEmailTaken = await _authService.isEmailTaken(_emailController.text);
        if (isEmailTaken) {
          _showError('این ایمیل قبلاً ثبت شده است');
          return;
        }

        // Register user
        final response = await _authService.signUp(
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
          username: _generatedUsername,
        );

        if (response?.user != null) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        }
      } catch (e) {
        _showError(e.toString());
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت‌نام'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'ایجاد حساب کاربری',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  textDirection: TextDirection.rtl,
                  enabled: !_isLoading,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'نام و نام خانوادگی',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا نام خود را وارد کنید';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  textDirection: TextDirection.ltr,
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'شماره موبایل',
                    hintText: '09123456789',
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا شماره موبایل خود را وارد کنید';
                    }
                    if (value.length != 11 || !value.startsWith('09')) {
                      return 'لطفا یک شماره موبایل معتبر وارد کنید';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'ایمیل',
                    hintText: 'example@domain.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا ایمیل خود را وارد کنید';
                    }
                    
                    // Comprehensive email validation
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      caseSensitive: false,
                    );
                    
                    if (!emailRegex.hasMatch(value)) {
                      return 'لطفا یک ایمیل معتبر وارد کنید (مثال: example@domain.com)';
                    }

                    // Additional checks
                    if (value.startsWith('.') || value.endsWith('.')) {
                      return 'ایمیل نمی‌تواند با نقطه شروع یا تمام شود';
                    }
                    
                    if (value.contains('..')) {
                      return 'ایمیل نمی‌تواند شامل دو نقطه پشت سر هم باشد';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'نام کاربری شما:',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _generatedUsername,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textDirection: TextDirection.ltr,
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'رمز عبور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا رمز عبور را وارد کنید';
                    }
                    if (value.length < 6) {
                      return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  textDirection: TextDirection.ltr,
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleRegister(),
                  decoration: InputDecoration(
                    labelText: 'تکرار رمز عبور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا تکرار رمز عبور را وارد کنید';
                    }
                    if (value != _passwordController.text) {
                      return 'رمز عبور و تکرار آن یکسان نیستند';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('ثبت‌نام'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.pop(context);
                  },
                  child: const Text('قبلاً ثبت‌نام کرده‌اید؟ وارد شوید'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 