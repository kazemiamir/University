import 'package:flutter/material.dart';
import 'models/product.dart';
import 'package:flutter/services.dart';
import  'screens/login_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // نوارها جدا از برنامه با رنگ سفید
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white, // نوار پایین سفید
    statusBarIconBrightness: Brightness.dark, // آیکون‌ها مشکی
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  runApp(const GadgetZoneApp());
}

class GadgetZoneApp extends StatelessWidget {
  const GadgetZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GadgetZone',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: LoginScreen(),

    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('GadgetZone'),
      ),
      body: ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.description),
      trailing: Text('${product.price.toStringAsFixed(0)} تومان'),
    );
  },
),

    );
  }
}


final List<Product> products = [
  Product(name: 'گوشی هوشمند', description: 'گوشی با دوربین عالی', price: 12_000_000),
  Product(name: 'لپ‌تاپ', description: 'لپ‌تاپ مناسب برنامه‌نویسی', price: 25_000_000),
  Product(name: 'هدفون بی‌سیم', description: 'کیفیت صدای بالا', price: 3_000_000),
];
