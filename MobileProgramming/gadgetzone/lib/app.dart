import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'services/user_manager.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(
              create: (_) => SettingsProvider(snapshot.data!),
            ),
          ],
          child: Consumer2<ThemeProvider, SettingsProvider>(
            builder: (context, themeProvider, settingsProvider, child) {
              final initialRoute = UserManager.isLoggedIn ? Routes.main : Routes.login;
              
              return MaterialApp(
                title: 'GadgetZone',
                theme: themeProvider.theme.copyWith(
                  textTheme: themeProvider.theme.textTheme.apply(
                    fontFamily: 'Vazir',
                  ),
                ),
                locale: const Locale('fa', 'IR'),
                builder: (context, child) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: child ?? const SizedBox(),
                  );
                },
                initialRoute: initialRoute,
                routes: Routes.getRoutes(),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
    );
  }
} 