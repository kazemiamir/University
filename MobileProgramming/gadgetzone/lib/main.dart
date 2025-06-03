import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'screens/auth/login_screen.dart';
import 'services/supabase_config.dart';
import 'dart:io' show Platform;
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'screens/home_page.dart';
import 'screens/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/theme_provider.dart';
import 'services/user_service.dart';
import 'providers/auth_provider.dart';
import 'services/database_service.dart';
import 'app.dart';
import 'services/user_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('\n=== اطلاعات سیستم ===');
  print('سیستم عامل: ${Platform.operatingSystem}');
  print('نسخه سیستم عامل: ${Platform.operatingSystemVersion}');
  print('تعداد تلاش‌های مجدد: 3');
  print('فاصله بین تلاش‌ها: 5 ثانیه');
  print('=====================\n');

  bool isConnected = false;
  int retryCount = 0;
  const maxRetries = 3;
  const retryDelay = Duration(seconds: 5);

  while (!isConnected && retryCount < maxRetries) {
    try {
      if (retryCount > 0) {
        print('\n=== تلاش مجدد ${retryCount + 1} از $maxRetries ===');
        print('در حال انتظار به مدت ${retryDelay.inSeconds} ثانیه...');
        await Future.delayed(retryDelay);
      }

      print('تست اتصال...');
      await Supabase.initialize(
        url: 'https://djsjjgkwffqhlrtrdwda.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqc2pqZ2t3ZmZxaGxydHJkd2RhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NTQ4OTgsImV4cCI6MjA2MzMzMDg5OH0.uIJ-T8gd5Rs4v-2O2MD5AmIcsmGCQvIFoZPStyevAC8',
      );
      
      // Initialize user manager and database
      await UserManager.initialize();
      await DatabaseService.initializeDatabase();
      
      isConnected = true;
      print('اتصال با موفقیت برقرار شد');
      break;

    } catch (e) {
      print('\n!!! خطا در تلاش ${retryCount + 1} !!!');
      print('نوع خطا: ${e.runtimeType}');
      print('پیام خطا: $e');
      retryCount++;
      
      if (retryCount >= maxRetries) {
        print('\n=== تمام تلاش‌ها ناموفق بود ===');
        print('لطفاً موارد زیر را بررسی کنید:');
        print('1. اتصال اینترنت خود را چک کنید');
        print('2. پورت‌های 80 و 443 در فایروال باز باشند');
        print('3. برنامه را کاملاً ببندید و دوباره اجرا کنید');
        print('4. کش برنامه را پاک کنید');
        print('============================\n');
      }
    }
  }
  
  runApp(const App());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'GadgetZone',
            theme: themeProvider.theme,
            locale: const Locale('fa', 'IR'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fa', 'IR'),
            ],
            initialRoute: Routes.home,
            routes: Routes.getRoutes(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
