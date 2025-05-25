import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: const Center(
        child: Text(
          'This is the Product Details Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
} 