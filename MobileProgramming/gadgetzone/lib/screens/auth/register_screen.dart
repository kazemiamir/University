import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes.dart';
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
  String _generatedUsername = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // TODO: Add actual registration logic here
      Navigator.pushReplacementNamed(context, Routes.home);
    }
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
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
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
                  decoration: const InputDecoration(
                    labelText: 'ایمیل',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا ایمیل خود را وارد کنید';
                    }
                    if (!value.contains('@')) {
                      return 'لطفا یک ایمیل معتبر وارد کنید';
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
                  decoration: InputDecoration(
                    labelText: 'رمز عبور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
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
                  decoration: InputDecoration(
                    labelText: 'تکرار رمز عبور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
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
                  onPressed: _handleRegister,
                  child: const Text('ثبت‌نام'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
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