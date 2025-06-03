import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_button.dart';
import '../../services/sms_service.dart';
import '../../routes.dart';
import '../../services/user_manager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isOtpSent = false;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _generateRandomUsername();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _generateRandomUsername() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    String username = 'user_';
    for (int i = 0; i < 6; i++) {
      username += chars[random.nextInt(chars.length)];
    }
    _usernameController.text = username;
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (!_isOtpSent) {
        // Test API credentials first
        final isCredentialsValid = await SMSService.testAPICredentials();
        if (!isCredentialsValid) {
          throw 'خطا در اعتبارسنجی سرویس پیامک. لطفاً با پشتیبانی تماس بگیرید';
        }

        // Check if phone number is already registered
        final isPhoneTaken = await _authService.isPhoneNumberTaken(_phoneController.text);
        if (isPhoneTaken) {
          throw 'این شماره موبایل قبلاً ثبت شده است. لطفاً وارد شوید.';
        }

        // Send OTP
        await _authService.startSignUp(
          name: _nameController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          username: _usernameController.text,
        );

        setState(() => _isOtpSent = true);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('کد تایید ارسال شد')),
          );
        }
      } else {
        // Verify OTP and complete registration
        final user = await _authService.completeSignUp(
          phone: _phoneController.text,
          token: _otpController.text,
        );

        if (user != null && mounted) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت‌نام'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isOtpSent) ...[
                CustomTextField(
                  controller: _nameController,
                  label: 'نام و نام خانوادگی',
                  validator: Validators.required,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  label: 'شماره موبایل',
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _usernameController,
                        label: 'نام کاربری',
                        validator: Validators.username,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    IconButton(
                      onPressed: _generateRandomUsername,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'تولید نام کاربری جدید',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: 'رمز عبور',
                  obscureText: true,
                  validator: Validators.password,
                  textInputAction: TextInputAction.done,
                ),
              ] else ...[
                const Text(
                  'کد تایید به شماره موبایل شما ارسال شد',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _phoneController.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'کد تایید',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'لطفا کد تایید را وارد کنید';
                    }
                    if (value!.length != 6) {
                      return 'کد تایید باید ۶ رقم باشد';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
              LoadingButton(
                onPressed: _signUp,
                isLoading: _isLoading,
                label: _isOtpSent ? 'تایید' : 'ثبت‌نام',
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('قبلاً ثبت‌نام کرده‌اید؟ وارد شوید'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 