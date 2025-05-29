import 'package:flutter/material.dart';
import 'routes.dart';
import 'screens/auth/login_screen.dart';
import 'services/supabase_config.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool isConnected = false;
  int retryCount = 0;
  const maxRetries = 3;
  const retryDelay = Duration(seconds: 5);

  print('\n=== اطلاعات سیستم ===');
  print('سیستم عامل: ${Platform.operatingSystem}');
  print('نسخه سیستم عامل: ${Platform.operatingSystemVersion}');
  print('تعداد تلاش‌های مجدد: $maxRetries');
  print('فاصله بین تلاش‌ها: ${retryDelay.inSeconds} ثانیه');
  print('=====================\n');

  while (!isConnected && retryCount < maxRetries) {
    try {
      if (retryCount > 0) {
        print('\n=== تلاش مجدد ${retryCount + 1} از $maxRetries ===');
        print('در حال انتظار به مدت ${retryDelay.inSeconds} ثانیه...');
        await Future.delayed(retryDelay);
      }

      print('شروع مقداردهی اولیه Supabase...');
      await SupabaseConfig.initialize();
      
      print('تست اتصال...');
      isConnected = await SupabaseConfig.checkConnection();
      
      if (!isConnected) {
        throw Exception('تست اتصال ناموفق بود');
      }
      
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
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GadgetZone',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.purple,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.purple),
          ),
        ),
      ),
      initialRoute: Routes.home,
      routes: Routes.getRoutes(),
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
