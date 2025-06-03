import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, SettingsProvider>(
      builder: (context, themeProvider, settingsProvider, child) {
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
                leading: const Icon(Icons.arrow_back_ios, size: 16),
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
                value: settingsProvider.notificationsEnabled,
                onChanged: (value) {
                  settingsProvider.toggleNotifications(value);
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
                leading: const Icon(Icons.arrow_back_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('شرایط و قوانین'),
                      content: const SingleChildScrollView(
                        child: Text(
                          '''
1. کلیات
- این برنامه صرفاً جهت خرید و فروش محصولات الکترونیکی می‌باشد.
- کلیه حقوق مادی و معنوی این برنامه متعلق به گجت زون می‌باشد.

2. حریم خصوصی
- اطلاعات شخصی کاربران محرمانه بوده و به هیچ عنوان در اختیار اشخاص ثالث قرار نمی‌گیرد.
- کاربران موظف به حفظ و نگهداری از اطلاعات حساب کاربری خود می‌باشند.

3. خرید و فروش
- قیمت‌های درج شده شامل مالیات بر ارزش افزوده می‌باشد.
- هزینه ارسال بر عهده خریدار است.
- امکان مرجوع کالا تا 7 روز پس از خرید وجود دارد.

4. گارانتی و خدمات پس از فروش
- کلیه محصولات دارای گارانتی معتبر می‌باشند.
- خدمات پس از فروش به مدت یک سال ارائه می‌گردد.
''',
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('تایید'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('حریم خصوصی'),
                leading: const Icon(Icons.arrow_back_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('حریم خصوصی'),
                      content: const SingleChildScrollView(
                        child: Text(
                          '''
1. جمع‌آوری اطلاعات
- نام و نام خانوادگی
- شماره تماس
- آدرس ایمیل
- آدرس محل سکونت

2. استفاده از اطلاعات
- ارائه خدمات بهتر به کاربران
- ارسال محصولات خریداری شده
- اطلاع‌رسانی درباره تخفیف‌ها و پیشنهادات ویژه

3. حفاظت از اطلاعات
- استفاده از پروتکل‌های امنیتی پیشرفته
- رمزنگاری اطلاعات حساس
- عدم به اشتراک‌گذاری با اشخاص ثالث

4. حقوق کاربران
- دسترسی به اطلاعات شخصی
- اصلاح اطلاعات نادرست
- حذف حساب کاربری
''',
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('تایید'),
                        ),
                      ],
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