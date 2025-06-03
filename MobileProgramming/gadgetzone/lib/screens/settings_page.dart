import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'فارسی';

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('تنظیمات'),
          ),
          body: ListView(
            children: [
              // تنظیمات ظاهری
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'تنظیمات ظاهری',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('حالت تاریک'),
                subtitle: const Text('تغییر رنگ‌بندی برنامه به حالت تاریک'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleDarkMode();
                },
              ),
              ListTile(
                title: const Text('تم برنامه'),
                subtitle: Text(themeProvider.themeMode),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('انتخاب تم'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile(
                            title: const Text('سیستم'),
                            value: 'سیستم',
                            groupValue: themeProvider.themeMode,
                            onChanged: (value) {
                              themeProvider.setThemeMode(value.toString());
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('روشن'),
                            value: 'روشن',
                            groupValue: themeProvider.themeMode,
                            onChanged: (value) {
                              themeProvider.setThemeMode(value.toString());
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('تاریک'),
                            value: 'تاریک',
                            groupValue: themeProvider.themeMode,
                            onChanged: (value) {
                              themeProvider.setThemeMode(value.toString());
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Divider(),

              // تنظیمات زبان
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'تنظیمات زبان',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('زبان برنامه'),
                subtitle: Text(_selectedLanguage),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('انتخاب زبان'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile(
                            title: const Text('فارسی'),
                            value: 'فارسی',
                            groupValue: _selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguage = value.toString();
                              });
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('English'),
                            value: 'English',
                            groupValue: _selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguage = value.toString();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Divider(),

              // تنظیمات اعلان‌ها
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'تنظیمات اعلان‌ها',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('اعلان‌ها'),
                subtitle: const Text('دریافت اعلان‌های پیشنهادات ویژه و تخفیف‌ها'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  // TODO: فعال/غیرفعال کردن اعلان‌ها
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('این قابلیت به زودی اضافه خواهد شد'),
                    ),
                  );
                },
              ),
              const Divider(),

              // درباره برنامه
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'درباره برنامه',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('نسخه برنامه'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('شرایط و قوانین'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: نمایش شرایط و قوانین
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('این قابلیت به زودی اضافه خواهد شد'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('حریم خصوصی'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: نمایش حریم خصوصی
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('این قابلیت به زودی اضافه خواهد شد'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 