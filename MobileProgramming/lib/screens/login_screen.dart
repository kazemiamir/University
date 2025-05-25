import 'package:flutter/material.dart';

/// Login screen widget that will be implemented in the next phase
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Login Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
} 