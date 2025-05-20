import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gadgetzone/screens/signupscreen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoginEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLoginState();
    _phoneController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    setState(() {
      _isLoginEnabled = _phoneController.text.length == 11 &&
          _passwordController.text.length >= 6;
    });
  }

  Future<void> _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> _checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    // TODO: هدایت کاربر به صفحه اصلی
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'ورود به GadgetZone',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
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
                    LengthLimitingTextInputFormatter(8),
                  ],
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoginEnabled
                      ? () {
                          _saveLoginState();
                          _navigateToHome();
                        }
                      : null,
                  child: const Text('ورود'),
                ),
                TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  },
  child: const Text('حساب کاربری ندارید؟ ثبت‌نام'),
),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}