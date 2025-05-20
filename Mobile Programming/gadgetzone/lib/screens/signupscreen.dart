import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadgetzone/screens/login_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isSignUpEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateInputs);
    _phoneController.addListener(_validateInputs);
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
    _confirmPasswordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    setState(() {
      _isSignUpEnabled = _nameController.text.isNotEmpty &&
          _phoneController.text.length == 11 &&
          _emailController.text.contains('@') &&
          _passwordController.text.length >= 6 &&
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ثبت‌نام در GadgetZone',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'نام کامل',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'شماره تلفن',
                  border: OutlineInputBorder(),
                  prefixText: '+98 ',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'ایمیل',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'رمز عبور',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                inputFormatters: [LengthLimitingTextInputFormatter(16)],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'تأیید رمز عبور',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSignUpEnabled ? () {
                  // TODO: ثبت نام کاربر
                } : null,
                child: const Text('ثبت‌نام'),
              ),
              TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(), // صفحه ورود
      ),
    );
  },
  child: const Text('حساب کاربری دارید؟ ورود'),
),
            ],
          ),
        ),
      ),
    );
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
}