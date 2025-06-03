import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../widgets/loading_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final phone = AuthService.userPhone;
      if (phone == null) {
        throw 'شماره موبایل یافت نشد. لطفاً دوباره ثبت‌نام کنید';
      }

      await _authService.verifyOTP(
        phone: phone,
        token: _otpController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
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
        title: const Text('تایید شماره موبایل'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'کد تایید به شماره موبایل شما ارسال شد',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              if (AuthService.userPhone != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    AuthService.userPhone!,
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
              const SizedBox(height: 24),
              LoadingButton(
                onPressed: _verifyOTP,
                isLoading: _isLoading,
                label: 'تایید',
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                child: const Text('بازگشت به صفحه ثبت‌نام'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 