import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isOtpSent = false;
  String? _userEmail;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.signIn(
          phone: _phoneController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('کد تایید به ایمیل شما ارسال شد'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _isOtpSent = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _handleVerifyOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _authService.verifyOTP(
          email: AuthService.userEmail!,
          token: _otpController.text,
        );

        if (response.user != null && mounted) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.shopping_bag,
                      size: 80,
                      color: Colors.purple,
                    );
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'خوش آمدید',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isOtpSent ? 'لطفا کد تایید را وارد کنید' : 'لطفا برای ادامه وارد شوید',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (!_isOtpSent) ...[
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    textDirection: TextDirection.ltr,
                    enabled: !_isLoading,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSendOTP(),
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
                ] else ...[
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    enabled: !_isLoading,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleVerifyOTP(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'کد تایید',
                      hintText: '123456',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'لطفا کد تایید را وارد کنید';
                      }
                      if (value.length != 6) {
                        return 'کد تایید باید ۶ رقمی باشد';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : (_isOtpSent ? _handleVerifyOTP : _handleSendOTP),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(_isOtpSent ? 'تایید' : 'ورود'),
                ),
                if (_isOtpSent) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _isLoading ? null : _handleSendOTP,
                    child: const Text('ارسال مجدد کد'),
                  ),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.pushNamed(context, Routes.register);
                  },
                  child: const Text('حساب کاربری ندارید؟ ثبت‌نام کنید'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 